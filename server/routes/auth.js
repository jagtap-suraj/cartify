import express from "express";
import { Router } from "express";
import bcryptjs from "bcryptjs";
import User from "../models/user.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import authMiddleware from "../middlewares/authMiddleware.js";
dotenv.config();

const authRouter = Router(); // Router for handling authentication routes.

// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body; // Extracting name, email and password from request body.

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
    console.error(e); // Log the detailed error for server-side debugging
    res
      .status(500)
      .json({ error: "An unexpected error occurred. Please try again later." });
  }
});

// SIGN IN
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User doesn't exist!" });
    }
    // Two passwords can never have same hashed value so we have to use the compare method of bcryptjs
    const isMatched = await bcryptjs.compare(password, user.password);
    if (!isMatched) {
      return res.status(400).json({ msg: "Incorrect Password" });
    }
    /**
     *  jwt.sign function for signing a payload with a secret or private key.
     *
     * The { id: user._id } passed in curly braces is an object literal that will be encoded into the JWT.
     * an object with a single property id is created, where the value of id is set to user_.id.
     * This object is used as the payload parameter for the jwt.sign function.
     * The payload in JWT (JSON Web Token) is the data that you want to securely transmit.
     *
     * The "passwordKey" is a string used as the secretOrPrivateKey parameter in the jwt.sign function
     * This is a secret key used for HMAC algorithms to sign the token.
     * The choice of "passwordKey" here is arbitrary for demonstration purposes;
     *
     * This token can be used for authenticating subsequent requests from the client.
     */
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRETORPRIVATEKEY
    );
    /**
     * ...user._doc uses the spread operator (...) to copy properties from user._doc into a new object.
     * user._doc contains the user's document data from MongoDB, excluding Mongoose-specific methods or properties.
     */

    /**
     * Suppose user._doc looks like this:
     * {
        _id: "123",
        username: "johnDoe",
        email: "john@example.com",
        // Mongoose properties and methods are not shown here
        }
      * The response sent back to the client would be a JSON object including the token and the user's data:
      * {
          "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "id": "123",
          "username": "johnDoe",
          "email": "john@example.com"
        }
     */
    res.json({ token, ...user._doc });
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ error: "An unexpected error occurred. Please try again later." });
  }
});

// ISTOKENVALID
authRouter.post("/api/istokenvalid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const isVerified = jwt.verify(token, process.env.JWT_SECRETORPRIVATEKEY);
    if (!isVerified) return res.json(false);
    // isVerified.id gives us the user id as we have used { id: user._id } while signing the token.
    const user = await User.findById(isVerified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    console.error(e);
    res.json(false);
  }
});

// GET USER
// GET USER
authRouter.get("/", authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user);;
    // Combine the token and user document into a single response
    res.json({ token: req.token, ...user._doc });
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ error: "An unexpected error occurred. Please try again later." });
  }
});

export default authRouter; // Export the authRouter i.e. the router for handling authentication routes.
