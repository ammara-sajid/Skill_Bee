<?php
header('Content-Type: application/json');

// Database connection
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]);
    exit();
}

// Allow only POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid request method. Use POST."]);
    exit();
}

// Validate input
$username = isset($_POST['username']) ? trim($_POST['username']) : null;
$email = isset($_POST['email']) ? trim($_POST['email']) : null;
$passwordRaw = isset($_POST['password']) ? $_POST['password'] : null;

if (!$username || !$email || !$passwordRaw) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit();
}

// Hash password
$password = password_hash($passwordRaw, PASSWORD_DEFAULT);

// Insert into database (use prepared statement to prevent SQL injection)
$stmt = $conn->prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $username, $email, $password);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "User registered successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
