import { Router } from "express";
import Joi from "joi";
import Product from "../models/product.js";
import authMiddleware from "../middlewares/authMiddleware.js";
import User from "../models/user.js";

const userRouter = Router();

// If the cart is not empty, it checks whether the product is already in the cart.
// It iterates through the cart items, checking if any item's product ID matches the ID of the product to be added.
// If found (isProductFound becomes true), it means the product is already in the cart.
// If the product is found in the cart, it finds that specific cart item and increments its quantity by 1.
// If the product is not found in the cart, it adds the product to the cart with a quantity of 1.
userRouter.post("/api/products/addtocart", authMiddleware, async (req, res) => {
  try {
    const { productId } = req.body;
    const product = await Product.findById(productId);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      // Check if the product is already in the cart, if yes, increment the quantity by 1
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default userRouter;
