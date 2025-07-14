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

// Middleware
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// MongoDB connection
const MONGODB_URI = "mongodb+srv://clouddoc22:HFklBdH0jKav2zYy@foodcluster0.crhcuot.mongodb.net/?retryWrites=true&w=majority&appName=foodCluster0"

mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((error) => console.error("MongoDB connection error:", error))

// Routes
app.use("/api/auth", authRoutes)
app.use("/api/donations", donationRoutes)
app.use("/api/requests", requestRoutes)
app.use("/api/users", userRoutes)

// Health check route
app.get("/api/health", (req, res) => {
  res.json({ message: "Food Donation API is running!" })
})

// Error handling middleware
app.use((error, req, res, next) => {
  console.error(error)
  res.status(500).json({ message: "Something went wrong!" })
})

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({ message: "Route not found" })
})

const PORT = process.env.PORT || 3001

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`)
})
