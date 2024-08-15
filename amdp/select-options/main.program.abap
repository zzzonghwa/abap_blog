* SELECT-OPTIONS
TABLES: sflight.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_carrid TYPE s_carrid OBLIGATORY DEFAULT 'AA'.
SELECT-OPTIONS: s_date FOR sflight-fldate DEFAULT '20240801' TO '20251001',
                  s_pt FOR sflight-planetype DEFAULT 'A319-100'.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  TRY.
      DATA(where_clause) =
      cl_shdb_seltab=>combine_seltabs(
          it_named_seltabs = VALUE #(
              ( name = 'FLDATE' dref = REF #( s_date[] ) )
              ( name = 'PLANETYPE' dref = REF #( s_pt[] ) )
          )
      ). 
*   where_clause 값 
*   ( FLDATE BETWEEN '20240801' AND '20251001') AND( PLANETYPE = 'A319-100')
    CATCH cx_shdb_exception INTO DATA(cx_shdb).

      MESSAGE cx_shdb->get_text(  ) TYPE 'E'.
      LEAVE LIST-PROCESSING.

  ENDTRY.

  