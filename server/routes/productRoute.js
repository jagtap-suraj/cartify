import { Router } from "express";
import Joi from "joi";
import Product from "../models/product.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const productRouter = Router();

const productSearchSchema = Joi.object({
  category: Joi.string(),
  search: Joi.string(),
}).or("category", "search");

// search and filter products by category or search term
productRouter.get("/api/products", authMiddleware, async (req, res) => {
  const { error } = productSearchSchema.validate(req.query);
  if (error) {
    return res.status(422).json({ errors: error.details });
  }

  const { category, search } = req.query;

  try {
    let query = {};

    if (category) {
      query.category = category;
    }

    if (search) {
      query.$or = [
        { name: { $regex: search, $options: "i" } },
        { description: { $regex: search, $options: "i" } },
      ];
    }

    const products = await Product.find(query);
    res.json(products);
  } catch (e) {
    console.error(e);
    res.status(500).json({
      error: "An unexpected error occurred. Please try again later.",
    });
  }
});

const ratingSchema = Joi.object({
  rating: Joi.number().min(1).max(5).required(),
});

// post rating for a product
productRouter.post(
  "/api/products/:productId/rating",
  authMiddleware,
  async (req, res) => {
    const { error } = ratingSchema.validate(req.body);
    if (error) {
      return res.status(422).json({ errors: error.details });
    }

    const { rating } = req.body;
    const { productId } = req.params;

    try {
      let product = await Product.findById(productId);
      if (!product) {
        return res.status(404).json({ error: "Product not found." });
      }
      // Find the user's rating for the product, if it exists
      let userRatingIndex = product.ratings.findIndex(
        (r) => r.userId.toString() === req.user
      );
      if (userRatingIndex !== -1) {
        // Update existing rating
        product.ratings[userRatingIndex].rating = rating;
      } else {
        // Add new rating
        product.ratings.push({ userId: req.user, rating });
      }
      await product.save();
      res.json(product);
    } catch (e) {
      console.error(e);
      res.status(500).json({
        error: "An unexpected error occurred. Please try again later.",
      });
    }
  }
);

// Deal of the day base on the highest rating
productRouter.get("/api/products/dealoftheday", authMiddleware, async (req, res) => {
  try {
    const products = await Product.aggregate([
      { $unwind: "$ratings" },
      {
        $group: {
          _id: "$_id",
          name: { $first: "$name" },
          description: { $first: "$description" },
          images: { $first: "$images" },
          quantity: { $first: "$quantity" },
          price: { $first: "$price" },
          category: { $first: "$category" },
          sellerId: { $first: "$sellerId" },
          averageRating: { $avg: "$ratings.rating" },
          totalRatings: { $sum: 1 },
        },
      },
      { $sort: { averageRating: -1, totalRatings: -1 } },
      { $limit: 1 },
    ]);

    if (products.length > 0) {
      res.json(products[0]);
    } else {
      res.status(404).json({ error: "No products found." });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default productRouter;
