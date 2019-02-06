# Derived table of numbers and dates (Redshift Implementation)

view: numbers {
  derived_table: {
    sql_trigger_value: SELECT CURRENT_DATE ;;
    sortkeys: ["number"]
    distribution_style: all
    sql: SELECT
          p0.n
          + p1.n*2
          + p2.n * POWER(2,2)
          + p3.n * POWER(2,3)
          + p4.n * POWER(2,4)
          + p5.n * POWER(2,5)
          + p6.n * POWER(2,6)
          + p7.n * POWER(2,7)
          + p8.n * POWER(2,8)
          as number
          FROM
          (SELECT 0 as n UNION SELECT 1) p0,
          (SELECT 0 as n UNION SELECT 1) p1,
          (SELECT 0 as n UNION SELECT 1) p2,
          (SELECT 0 as n UNION SELECT 1) p3,
          (SELECT 0 as n UNION SELECT 1) p4,
          (SELECT 0 as n UNION SELECT 1) p5,
          (SELECT 0 as n UNION SELECT 1) p6,
          (SELECT 0 as n UNION SELECT 1) p7,
          (SELECT 0 as n UNION SELECT 1) p8
       ;;
  }

  dimension: number {
    type: number
    sql: ${TABLE}.number ;;
  }
}

view: dates {
  derived_table: {
    sql_trigger_value: SELECT CURRENT_DATE ;;
    sortkeys: ["series_date"]
    distribution_style: all

    sql:
      SELECT
          DATEADD(day, 1-numbers.number::integer, CURRENT_DATE)
        AS series_date
      FROM ${numbers.SQL_TABLE_NAME} AS numbers ;;
  }

  dimension_group: event {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    sql: ${TABLE}.series_date ;;
  }
}
