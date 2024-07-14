import { Router } from "express";
import Joi from "joi";
import Product from "../models/product.js";
import authMiddleware from "../middlewares/authMiddleware.js";
const productRouter = Router();

const productCategorySchema = Joi.object({
  category: Joi.string().required(),
});

productRouter.get("/api/products", authMiddleware, async (req, res) => {
  const { error } = productCategorySchema.validate(req.query);
  if (error) {
    return res.status(422).json({ errors: error.details });
  }

  const { category } = req.query;
  try {
    // Find all products with the given category
    const products = await Product.find({ category });
    res.json(products);
  } catch (e) {
    console.error(e);
    res.status(500).json({
      error: "An unexpected error occurred. Please try again later.",
    });
  }
});

export default productRouter;
