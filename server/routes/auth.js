import express from "express";
import { Router } from "express";
import bcryptjs from "bcryptjs";
import User from "../models/user.js";

const authRouter = Router(); // Router for handling authentication routes.

// SIGN UP
authRouter.post("/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      name,
      email,
      password: hashedPassword,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default authRouter; // Export the authRouter i.e. the router for handling authentication routes.
