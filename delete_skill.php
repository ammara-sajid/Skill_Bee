<?php
header('Content-Type: application/json');

// ✅ Database connection
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// ✅ Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // ✅ Check for required fields
    if (!isset($_POST['user_id']) || !isset($_POST['skill_name'])) {
        echo json_encode(["status" => "error", "message" => "Missing parameters"]);
        exit;
    }

    $user_id = intval($_POST['user_id']);
    $skill_name = trim($_POST['skill_name']);

    // ✅ Delete the skill from the database
    $sql = "DELETE FROM skills WHERE user_id = ? AND skill_name = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("is", $user_id, $skill_name);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode(["status" => "success", "message" => "Skill deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Skill not found or already deleted"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to delete skill"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
