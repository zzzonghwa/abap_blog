CLASS zcl_flights_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_amdp_marker_hdb.
    TYPES: BEGIN OF ts_sflights,
             carrid    TYPE s_carr_id,
             connid    TYPE s_conn_id,
             fldate    TYPE s_date,
             price     TYPE s_price,
             currency  TYPE s_currcode,
             planetype TYPE s_planetye,
             seatsmax  TYPE s_seatsmax,
             seatsocc  TYPE s_seatsocc,
           END OF ts_sflights.
    TYPES: tt_sflights TYPE TABLE OF ts_sflights
                       WITH DEFAULT KEY.

    CLASS-METHODS:
      get_filter_flights
        IMPORTING VALUE(iv_carrid) TYPE s_carr_id
                  VALUE(iv_where)  TYPE string
        EXPORTING VALUE(et_data)   TYPE tt_sflights.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_flights_model IMPLEMENTATION.

  METHOD get_filter_flights BY DATABASE PROCEDURE
                            FOR HDB
                            LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            USING sflight.

    et_data =
    select carrid, connid, fldate, price,
           currency, planetype, seatsmax, seatsocc
     from sflight
     where mandt = session_context( 'CLIENT' )
       and carrid = :iv_carrid;

    et_data = apply_filter( :et_data, :iv_where );

  ENDMETHOD.

ENDCLASS.