// import jwt
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

/**
 * Middleware to authenticate tokens in request headers. It verifies the authentication token,
 * passes control to the next middleware/route handler if the token is valid, or ends the
 * request-response cycle with an error response if the token is invalid or missing.
 * Additionally, it modifies the request object by adding the user's ID and the token to it,
 * which can then be used by subsequent middleware or route handlers.
 */
const authMiddleware = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token"); // Get the token from the request header.
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied" });
    }
    const isVerified = jwt.verify(token, process.env.JWT_SECRETORPRIVATEKEY);
    if (!isVerified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });
    }
    req.user = isVerified.id; // Add the user's ID to the request object.
    req.token = token; // Add the token to the request object.
    next(); // next is a callback to pass control to the next middleware function.
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ error: "An unexpected error occurred. Please try again later." });
  }
};

export default authMiddleware; // Export the authMiddleware function.
