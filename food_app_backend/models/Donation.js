const mongoose = require("mongoose")

const donationSchema = new mongoose.Schema(
  {
    donorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    foodType: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    quantity: {
      type: Number,
      required: true,
      min: 1,
    },
    unit: {
      type: String,
      required: true,
      enum: ["kg", "pieces", "liters", "packets", "boxes"],
    },
    expiryDate: {
      type: Date,
      required: true,
    },
    pickupAddress: {
      type: String,
      required: true,
      trim: true,
    },
    status: {
      type: String,
      enum: ["available", "requested", "completed"],
      default: "available",
    },
    requestedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    images: [
      {
        type: String,
      },
    ],
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  },
)

// Index for better query performance
donationSchema.index({ status: 1, createdAt: -1 })
donationSchema.index({ donorId: 1 })

module.exports = mongoose.model("Donation", donationSchema)
