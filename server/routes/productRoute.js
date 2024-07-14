import { Router } from "express";
import Joi from "joi";
import Product from "../models/product.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const productRouter = Router();

const productSearchSchema = Joi.object({
  category: Joi.string(),
  search: Joi.string(),
}).or("category", "search");

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

export default productRouter;
