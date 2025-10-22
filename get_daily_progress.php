<?php
header('Content-Type: application/json');
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "DB connection failed"]));
}

if (!isset($_POST['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$user_id = $_POST['user_id'];

// Example: count skills practiced per day (replace with your logic)
$sql = "SELECT DAYOFWEEK(created_at) as day, COUNT(*) as count 
        FROM skills 
        WHERE user_id='$user_id' 
        GROUP BY DAYOFWEEK(created_at)";
        
$result = $conn->query($sql);

$data = array_fill(1, 7, 0); // 7 days (Mon-Sun) default 0
while ($row = $result->fetch_assoc()) {
    $data[(int)$row['day']] = (int)$row['count'];
}

echo json_encode([
    "status" => "success",
    "progress" => $data
]);

$conn->close();
?>
