<html>
 <head>
  <title>my web page</title>
 </head>
 <body>
  <b>my first web page</b>
  <br>
  this is not bold


<?php
opcache_reset();
echo "<br> this is from php did this akdk?";
$anumbervariable = 4;
echo "<br> $anumbervariable";
$anumbervariable = $anumbervariable + 1;
echo "<br><br> $anumbervariable";

$servername = "localhost";
$username = "root";
$password = "inf130";
$dbname = "hobbyhuset";

$conn = new mysqli($servername,$username,$password,$dbname);

if ($conn->connect_error) {
    die("connection fail: " . $conn->connect_error);
} else {Echo "<br><br>success";}

$sql = "select ansnr,fornavn from ansatt";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
       echo "ansnr: " . $row["ansnr"]. " name: " . $row["fornavn"]. "<br>";
 }
}


?>


 
</body>
</html>