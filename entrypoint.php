<?php
require 'vendor/autoload.php';
$manager = new \MongoDB\Driver\Manager("mongodb://mongo:27017");
$collection = new \MongoDB\Collection($manager, "digitalbees.analytics", 'test');
$entityBody = json_decode(file_get_contents('php://input'));
try {
    http_response_code(200);
    $result = $collection->insertOne($entityBody);
    echo json_encode(['id' => $result->getInsertedId()]);
} catch (\Exception $exc) {
    http_response_code(500);
    throw $exc;
}
