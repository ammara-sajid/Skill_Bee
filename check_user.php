<?php
header('Content-Type: application/json');

// Database connection
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]);
    exit();
}

// Allow only POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid request method. Use POST."]);
    exit();
}

// Get and validate email
$email = isset($_POST['email']) ? trim($_POST['email']) : null;

if (!$email) {
    echo json_encode(["status" => "error", "message" => "Email is required"]);
    exit();
}

// Prepare statement to check if user exists
$stmt = $conn->prepare("SELECT id, username, email FROM users WHERE email = ? LIMIT 1");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

// Check if user exists
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "status" => "exists",
        "message" => "User already registered",
        "user" => $user
    ]);
} else {
    echo json_encode([
        "status" => "not_found",
        "message" => "User not registered"
    ]);
}

// Cleanup
$stmt->close();
$conn->close();
?>
