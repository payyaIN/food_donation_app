const express = require("express")
const { body, validationResult } = require("express-validator")
const Donation = require("../models/Donation")
const auth = require("../middleware/auth")

const router = express.Router()

// Create donation
router.post(
  "/",
  auth,
  [
    body("foodType").trim().notEmpty().withMessage("Food type is required"),
    body("description").trim().notEmpty().withMessage("Description is required"),
    body("quantity").isInt({ min: 1 }).withMessage("Quantity must be at least 1"),
    body("unit").isIn(["kg", "pieces", "liters", "packets", "boxes"]).withMessage("Invalid unit"),
    body("expiryDate").isISO8601().withMessage("Valid expiry date is required"),
    body("pickupAddress").trim().notEmpty().withMessage("Pickup address is required"),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg })
      }

      const donation = new Donation({
        ...req.body,
        donorId: req.user._id,
      })

      await donation.save()
      await donation.populate("donorId", "name email phone")

      res.status(201).json({
        message: "Donation created successfully",
        donation,
      })
    } catch (error) {
      console.error(error)
      res.status(500).json({ message: "Server error" })
    }
  },
)

// Get all available donations
router.get("/", async (req, res) => {
  try {
    const { page = 1, limit = 10, foodType, status = "available" } = req.query

    const query = { isActive: true }
    if (status) query.status = status
    if (foodType) query.foodType = new RegExp(foodType, "i")

    const donations = await Donation.find(query)
      .populate("donorId", "name email phone address")
      .populate("requestedBy", "name email phone")
      .sort({ createdAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit)

    const total = await Donation.countDocuments(query)

    res.json({
      donations,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Get user's donations
router.get("/my-donations", auth, async (req, res) => {
  try {
    const donations = await Donation.find({
      donorId: req.user._id,
      isActive: true,
    })
      .populate("requestedBy", "name email phone")
      .sort({ createdAt: -1 })

    res.json({ donations })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Get donation by ID
router.get("/:id", async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id)
      .populate("donorId", "name email phone address")
      .populate("requestedBy", "name email phone")

    if (!donation) {
      return res.status(404).json({ message: "Donation not found" })
    }

    res.json({ donation })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Request donation
router.put("/:id/request", auth, async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id)

    if (!donation) {
      return res.status(404).json({ message: "Donation not found" })
    }

    if (donation.status !== "available") {
      return res.status(400).json({ message: "Donation is not available" })
    }

    if (donation.donorId.toString() === req.user._id.toString()) {
      return res.status(400).json({ message: "You cannot request your own donation" })
    }

    donation.status = "requested"
    donation.requestedBy = req.user._id
    await donation.save()

    await donation.populate("donorId", "name email phone")
    await donation.populate("requestedBy", "name email phone")

    res.json({
      message: "Donation requested successfully",
      donation,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Complete donation
router.put("/:id/complete", auth, async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id)

    if (!donation) {
      return res.status(404).json({ message: "Donation not found" })
    }

    if (donation.donorId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    if (donation.status !== "requested") {
      return res.status(400).json({ message: "Donation is not in requested state" })
    }

    donation.status = "completed"
    await donation.save()

    await donation.populate("donorId", "name email phone")
    await donation.populate("requestedBy", "name email phone")

    res.json({
      message: "Donation completed successfully",
      donation,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Update donation
router.put("/:id", auth, async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id)

    if (!donation) {
      return res.status(404).json({ message: "Donation not found" })
    }

    if (donation.donorId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    if (donation.status !== "available") {
      return res.status(400).json({ message: "Cannot update donation that is not available" })
    }

    const updatedDonation = await Donation.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate(
      "donorId",
      "name email phone",
    )

    res.json({
      message: "Donation updated successfully",
      donation: updatedDonation,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Delete donation
router.delete("/:id", auth, async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id)

    if (!donation) {
      return res.status(404).json({ message: "Donation not found" })
    }

    if (donation.donorId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    donation.isActive = false
    await donation.save()

    res.json({ message: "Donation deleted successfully" })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

module.exports = router
