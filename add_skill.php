<?php
header('Content-Type: application/json');

// Database connection
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// ✅ Check if POST parameters exist
if (!isset($_POST['user_id']) || !isset($_POST['skill_name']) || !isset($_POST['category'])) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit;
}

$user_id = intval($_POST['user_id']);
$skill_name = trim($_POST['skill_name']);
$category = trim($_POST['category']);

// ✅ Prevent empty fields
if (empty($skill_name) || empty($category)) {
    echo json_encode(["status" => "error", "message" => "Skill name and category cannot be empty"]);
    exit;
}

// ✅ Insert into database
$sql = "INSERT INTO skills (user_id, category, skill_name, created_at) 
        VALUES ('$user_id', '$category', '$skill_name', NOW())";

if ($conn->query($sql) === TRUE) {
    echo json_encode([
        "status" => "success",
        "message" => "Skill added successfully",
        "skill" => [
            "id" => $conn->insert_id,
            "skill_name" => $skill_name,
            "category" => $category,
            "user_id" => $user_id
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
}

$conn->close();
?>
