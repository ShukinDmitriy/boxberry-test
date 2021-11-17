<?php
// php7,1+
// Вопросы инициализации подключения к бд опустим
/** @var PDO $connection */

// Заранее создадим индекс по цвету...

// Как-то так будет выглядеть конфигурация обновления цены
$newPrices = [
    'red' => 5, // Увеличиваем на 5%
    'green' => -10, // Уменьшаем на 10%
];

// Заведем переменную, чтобы выполнять обновления пачками
$part = 1000;

// неплохо бы понять все варианты цветов
foreach ($connection->query('select distinct color as color from products;') as $row) {
    $color = $row['color'];
    echo $color . "\n";

    // Если цвет не учли в конфигурации или цена не изменяется
    $price = $newPrices[$color] ?? 0;
    if (empty($price)) {
        continue;
    }

    // Проверим минимальную и максимальную запись
    list($minId, $maxId) = $connection->query("select min(id) as minId, max(id) as maxId from products where color = $color;")[0];

    // ну и запускаем обновление
    for($i = floor($minId / $part); $i < ceil($maxId / $part); $i++) {
        $startId = $i * $part;
        echo $startId . "\n";
        $endId = ($i + 1) * $part;
        $connection->query("update products set price = price * (100 + $price) / 100 where id > $startId and id <= $endId and color = $color;");
    }
}
