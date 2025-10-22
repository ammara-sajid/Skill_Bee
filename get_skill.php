<?php
header('Content-Type: application/json');
include 'db.php';

if (!isset($_POST['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$user_id = mysqli_real_escape_string($conn, $_POST['user_id']);

$query = "SELECT skill_name FROM skills WHERE user_id = '$user_id'";
$result = mysqli_query($conn, $query);

if (!$result) {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
    exit;
}

$skills = [];
while ($row = mysqli_fetch_assoc($result)) {
    $skills[] = $row['skill_name'];
}

echo json_encode(["status" => "success", "skills" => $skills]);
?>
