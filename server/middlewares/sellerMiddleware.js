import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/user.js";
dotenv.config();

const sellerMiddleware = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied" });
    }
    const isVerified = jwt.verify(token, process.env.JWT_SECRETORPRIVATEKEY);
    if (!isVerified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });
    }
    const user = await User.findById(isVerified.id);
    if (!user) {
      return res.status(401).json({ msg: "User does not exist" });
    }
    if (user.type !== "seller" && user.type !== "admin") {
      return res
        .status(401)
        .json({ msg: "You are not authorized to access seller resource" });
    }
    req.user = isVerified.id;
    req.token = token;
    next();
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ error: "An unexpected error occurred. Please try again later." });
  }
};

export default sellerMiddleware;
