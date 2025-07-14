const express = require("express")
const { body, validationResult } = require("express-validator")
const Request = require("../models/Request")
const auth = require("../middleware/auth")

const router = express.Router()

// Create request
router.post(
  "/",
  auth,
  [
    body("foodType").trim().notEmpty().withMessage("Food type is required"),
    body("description").trim().notEmpty().withMessage("Description is required"),
    body("quantity").isInt({ min: 1 }).withMessage("Quantity must be at least 1"),
    body("unit").isIn(["kg", "pieces", "liters", "packets", "boxes"]).withMessage("Invalid unit"),
    body("deliveryAddress").trim().notEmpty().withMessage("Delivery address is required"),
    body("urgency").isIn(["low", "medium", "high"]).withMessage("Invalid urgency level"),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg })
      }

      const request = new Request({
        ...req.body,
        requesterId: req.user._id,
      })

      await request.save()
      await request.populate("requesterId", "name email phone")

      res.status(201).json({
        message: "Request created successfully",
        request,
      })
    } catch (error) {
      console.error(error)
      res.status(500).json({ message: "Server error" })
    }
  },
)

// Get all pending requests
router.get("/", async (req, res) => {
  try {
    const { page = 1, limit = 10, foodType, urgency, status = "pending" } = req.query

    const query = { isActive: true }
    if (status) query.status = status
    if (foodType) query.foodType = new RegExp(foodType, "i")
    if (urgency) query.urgency = urgency

    const requests = await Request.find(query)
      .populate("requesterId", "name email phone address userType organizationName")
      .populate("fulfilledBy", "name email phone")
      .sort({ urgency: -1, createdAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit)

    const total = await Request.countDocuments(query)

    res.json({
      requests,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Get user's requests
router.get("/my-requests", auth, async (req, res) => {
  try {
    const requests = await Request.find({
      requesterId: req.user._id,
      isActive: true,
    })
      .populate("fulfilledBy", "name email phone")
      .sort({ createdAt: -1 })

    res.json({ requests })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Get request by ID
router.get("/:id", async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)
      .populate("requesterId", "name email phone address userType organizationName")
      .populate("fulfilledBy", "name email phone")

    if (!request) {
      return res.status(404).json({ message: "Request not found" })
    }

    res.json({ request })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Fulfill request
router.put("/:id/fulfill", auth, async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)

    if (!request) {
      return res.status(404).json({ message: "Request not found" })
    }

    if (request.status !== "pending") {
      return res.status(400).json({ message: "Request is not pending" })
    }

    if (request.requesterId.toString() === req.user._id.toString()) {
      return res.status(400).json({ message: "You cannot fulfill your own request" })
    }

    request.status = "fulfilled"
    request.fulfilledBy = req.user._id
    await request.save()

    await request.populate("requesterId", "name email phone")
    await request.populate("fulfilledBy", "name email phone")

    res.json({
      message: "Request fulfilled successfully",
      request,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Update request
router.put("/:id", auth, async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)

    if (!request) {
      return res.status(404).json({ message: "Request not found" })
    }

    if (request.requesterId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    if (request.status !== "pending") {
      return res.status(400).json({ message: "Cannot update request that is not pending" })
    }

    const updatedRequest = await Request.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate(
      "requesterId",
      "name email phone",
    )

    res.json({
      message: "Request updated successfully",
      request: updatedRequest,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Cancel request
router.put("/:id/cancel", auth, async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)

    if (!request) {
      return res.status(404).json({ message: "Request not found" })
    }

    if (request.requesterId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    if (request.status !== "pending") {
      return res.status(400).json({ message: "Can only cancel pending requests" })
    }

    request.status = "cancelled"
    await request.save()

    res.json({
      message: "Request cancelled successfully",
      request,
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

// Delete request
router.delete("/:id", auth, async (req, res) => {
  try {
    const request = await Request.findById(req.params.id)

    if (!request) {
      return res.status(404).json({ message: "Request not found" })
    }

    if (request.requesterId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized" })
    }

    request.isActive = false
    await request.save()

    res.json({ message: "Request deleted successfully" })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: "Server error" })
  }
})

module.exports = router
