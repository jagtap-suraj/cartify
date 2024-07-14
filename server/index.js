// Imports from packages
import express from "express";
import { connect } from "mongoose";
import dotenv from "dotenv";
dotenv.config();

// Imports from other files
import authRouter from "./routes/auth.js";
import sellerRouter from "./routes/seller.js";
import productRouter from "./routes/productRoute.js";

// Initialize the express app
const PORT = process.env.PORT || 3000;
const app = express();

// Middleware
app.use(express.json()); // Parse incoming requests with json payloads
app.use(authRouter); // Use the authRouter for handling authentication routes.
app.use(sellerRouter); // Use the sellerRouter for handling seller routes.
app.use(productRouter);

// Connections
connect(process.env.MONGODB_URI).then(() => {
  console.log("Connected to MongoDB");
});

/**
 * Start the server and listen on the specified port on the specified host and execute
 * the callback function.
 */
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
