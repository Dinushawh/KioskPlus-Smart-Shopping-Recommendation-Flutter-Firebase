<?php

	$servername = "localhost";
	$username = "debian-sys-maint";
	$password = "qzEUNoZ7xFXHoiqe";
	$dbname = "shopping_complex_db";

	$conn = new mysqli($servername, $username, $password, $dbname);

	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}

	$data = $_POST['data'];

	$sql = "INSERT INTO  test (`abc`) VALUES ('$data')";

	$stmt = $mysqli->prepare("INSERT INTO test ('abc') VALUES (?)");
	$stmt->bind_param("s", $data);
	$stmt->execute();

	$stmt->close();
	$mysqli->close();

	if ($conn->query($sql) === TRUE) {
	echo "New record created successfully";
	} else {
	echo "Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();
?>