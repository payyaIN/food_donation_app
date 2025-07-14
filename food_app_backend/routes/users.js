const express = require("express")
const User = require("../models/User")
const auth = require("../middleware/auth")

const router = express.Router()

// Get user profile
router.get("/profile", auth, async (req, res) => {
  try {
    res.json({ user: req.user })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Update user profile
router.put("/profile", auth, async (req, res) => {
  try {
    const { name, phone, address, organizationName, registrationNumber } = req.body

    const updateData = { name, phone, address }

    if (req.user.userType === "ngo") {
      updateData.organizationName = organizationName
      updateData.registrationNumber = registrationNumber
    }

    const user = await User.findByIdAndUpdate(req.user._id, updateData, { new: true })

    res.json({
      message: "Profile updated successfully",
      user,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Get all NGOs
router.get("/ngos", async (req, res) => {
  try {
    const ngos = await User.find({
      userType: "ngo",
      isActive: true,
    }).select("name email phone address organizationName registrationNumber")

    res.json({ ngos })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

module.exports = router
