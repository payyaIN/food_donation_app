

// const express = require("express")
// const mongoose = require("mongoose")
// const cors = require("cors")
// const dotenv = require("dotenv")

// // Import routes
// const authRoutes = require("./routes/auth")
// const donationRoutes = require("./routes/donations")
// const requestRoutes = require("./routes/requests")
// const userRoutes = require("./routes/users")

// dotenv.config()

// const app = express()

// // Middleware
// app.use(cors())
// app.use(express.json())
// app.use(express.urlencoded({ extended: true }))

// // Local MongoDB connection
// const MONGODB_URI = process.env.MONGODB_URI || "mongodb+srv://foodappuser:foodappdb@foodcluster0.crhcuot.mongodb.net/?retryWrites=true&w=majority&appName=foodCluster0"

// console.log('🔄 Connecting to local MongoDB...')

// mongoose
//   .connect(MONGODB_URI, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   })
//   .then(() => {
//     console.log("Connected to local MongoDB successfully!")
//     console.log(`Database: ${MONGODB_URI}`)
//   })
//   .catch((error) => {
//     console.error("MongoDB connection error:", error.message)
//   })

// // Routes
// app.use("/api/auth", authRoutes)
// app.use("/api/donations", donationRoutes)
// app.use("/api/requests", requestRoutes)
// app.use("/api/users", userRoutes)

// // Health check route
// app.get("/api/health", (req, res) => {
//   res.json({ 
//     message: "Food Donation API is running!",
//     database: "Local MongoDB",
//     timestamp: new Date().toISOString()
//   })
// })

// // Error handling middleware
// app.use((error, req, res, next) => {
//   console.error(error)
//   res.status(500).json({ message: "Something went wrong!" })
// })

// // 404 handler
// app.use("*", (req, res) => {
//   res.status(404).json({ message: "Route not found" })
// })

// const PORT = process.env.PORT || 3001

// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`)
//   console.log(`Health check: http://localhost:${PORT}/api/health`)
// })
const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")
const dotenv = require("dotenv")

// Import routes
const authRoutes = require("./routes/auth")
const donationRoutes = require("./routes/donations")
const requestRoutes = require("./routes/requests")
const userRoutes = require("./routes/users")

dotenv.config()

const app = express()

// Enhanced CORS configuration
app.use(cors({
  origin: ['http://localhost:3001', 'http://10.0.2.2:3001', 'http://127.0.0.1:3001','http://192.168.0.202:3001'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}))

// Middleware
app.use(express.json({ limit: '10mb' }))
app.use(express.urlencoded({ extended: true, limit: '10mb' }))

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`)
  next()
})

// MongoDB connection with better error handling
const MONGODB_URI = process.env.MONGODB_URI || "mongodb+srv://foodappuser:foodappdb@foodcluster0.crhcuot.mongodb.net/?retryWrites=true&w=majority&appName=foodCluster0"

console.log('🔄 Connecting to MongoDB...')

mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 5000, // Timeout after 5s instead of 30s
    socketTimeoutMS: 45000, // Close sockets after 45s of inactivity
    maxPoolSize: 10, // Maintain up to 10 socket connections
    serverSelectionTimeoutMS: 5000, // Keep trying to send operations for 5 seconds
    heartbeatFrequencyMS: 10000, // Send a ping every 10 seconds
  })
  .then(() => {
    console.log("✅ Connected to MongoDB successfully!")
    console.log(`Database: ${MONGODB_URI.split('@')[1]?.split('?')[0] || 'Hidden'}`)
  })
  .catch((error) => {
    console.error("❌ MongoDB connection error:", error.message)
    console.log("🔄 Retrying connection in 5 seconds...")
    setTimeout(() => {
      mongoose.connect(MONGODB_URI)
    }, 5000)
  })

// MongoDB connection event handlers
mongoose.connection.on('error', (error) => {
  console.error('MongoDB error:', error)
})

mongoose.connection.on('disconnected', () => {
  console.log('MongoDB disconnected')
})

mongoose.connection.on('reconnected', () => {
  console.log('MongoDB reconnected')
})

// Graceful shutdown
process.on('SIGINT', async () => {
  try {
    await mongoose.connection.close()
    console.log('MongoDB connection closed.')
    process.exit(0)
  } catch (error) {
    console.error('Error during shutdown:', error)
    process.exit(1)
  }
})

// Routes
app.use("/api/auth", authRoutes)
app.use("/api/donations", donationRoutes)
app.use("/api/requests", requestRoutes)
app.use("/api/users", userRoutes)

// Health check route
app.get("/api/health", (req, res) => {
  const healthCheck = {
    message: "Food Donation API is running!",
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    database: mongoose.connection.readyState === 1 ? "Connected" : "Disconnected",
    environment: process.env.NODE_ENV || "development",
    port: process.env.PORT || 3001
  }
  
  res.status(200).json(healthCheck)
})

// API documentation route
app.get("/api", (req, res) => {
  res.json({
    message: "Welcome to Food Donation API",
    version: "1.0.0",
    endpoints: {
      auth: "/api/auth",
      donations: "/api/donations",
      requests: "/api/requests",
      users: "/api/users",
      health: "/api/health"
    }
  })
})

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Server Error:', error)
  
  // Mongoose validation error
  if (error.name === 'ValidationError') {
    const messages = Object.values(error.errors).map(err => err.message)
    return res.status(400).json({ 
      message: "Validation Error", 
      errors: messages 
    })
  }

  // Mongoose duplicate key error
  if (error.code === 11000) {
    return res.status(400).json({ 
      message: "Duplicate field value entered" 
    })
  }

  // JWT errors
  if (error.name === 'JsonWebTokenError') {
    return res.status(401).json({ 
      message: "Invalid token" 
    })
  }

  if (error.name === 'TokenExpiredError') {
    return res.status(401).json({ 
      message: "Token expired" 
    })
  }

  // Default error
  res.status(error.statusCode || 500).json({ 
    message: error.message || "Something went wrong!",
    ...(process.env.NODE_ENV === 'development' && { stack: error.stack })
  })
})

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({ 
    message: "Route not found",
    path: req.originalUrl,
    method: req.method
  })
})

const PORT = process.env.PORT || 3001

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server is running on port ${PORT}`)
  console.log(`📡 Health check: http://localhost:${PORT}/api/health`)
  console.log(`📱 For Android emulator: http://10.0.2.2:${PORT}/api/health`)
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`)
})

// Handle server errors
server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`❌ Port ${PORT} is already in use`)
    process.exit(1)
  } else {
    console.error('Server error:', error)
  }
})

module.exports = app