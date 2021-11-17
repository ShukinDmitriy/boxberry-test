<?php

/**
 *
 * @param $startDT
 * @param $endDT
 * @param $dayName
 */
function dayOfWeekCount($startDT, $endDT, $dayName)
{
    $count = 0;
    $interval = new \DateInterval('P1D');
    $start = new \DateTime($startDT);
    $end = new \DateTime($endDT);
    // Даты могут перепутаны
    if ($start < $end) {
        $period = new \DatePeriod($start, $interval, $end);
    } else {
        $period = new \DatePeriod($end, $interval, $start);
    }

    foreach($period as $day){
        if($day->format('D') === ucfirst(substr($dayName, 0, 3))){
            $count ++;
        }
    }
    return $count;
}

// Для упрощения допустим, что даты приходят в формате 'Y-m-d'
$validatorPattern = '/^\d{4}-\d{2}-\d{2}$/';
if (preg_match($validatorPattern, $_GET['start']) !== 1 || preg_match($validatorPattern, $_GET['end']) !== 1) {
    exit('Переданы данные в неправильном формате');
}
echo dayOfWeekCount($_GET['start'], $_GET['end'],  'Tuesday');
