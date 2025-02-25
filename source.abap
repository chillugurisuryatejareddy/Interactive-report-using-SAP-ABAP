
TABLES: VBAK, EKKO.
SELECT-OPTIONS: S_KUNNR FOR VBAK-KUNNR MODIF ID G1,
                 I_LFNR FOR EKKO-LIFNR MODIF ID G2.

PARAMETERS: S1 RADIOBUTTON GROUP R1,
            S2 RADIOBUTTON GROUP R1.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'G1'.
      IF S1 = 'X'.
        Screen-ACTIVE = '1'.
        Screen-Intensified = '1'.
        Screen-Color = '3'.
     ELSE.
       SCREEN-ACTIVE = '0'.
     ENDIF.
    ELSEIF SCREEN-GROUP1 = 'G2'.
      IF S2 = 'X'.
        SCREEN-ACTIVE = '1'.
        Screen-Intensified = '1'.
        Screen-Color = '3'.
     ELSE.
        SCREEN-ACTIVE = 0.
     ENDIF.
    ENDIF.
    MODIFY SCREEN.

  ENDLOOP.









START-OF-SELECTION.

*PARAMETERS: s1 RADIOBUTTON GROUP r1 DEFAULT 'X'.

  DATA: LO_COLUMNS   TYPE REF TO CL_SALV_COLUMNS_TABLE,
        LO_COLUMN    TYPE REF TO CL_SALV_COLUMN_TABLE,
        LO_COLUMNS_1 TYPE REF TO CL_SALV_COLUMNS_TABLE,
        LO_COLUMN_1  TYPE REF TO CL_SALV_COLUMN_TABLE.

  CLASS LCL_EVENTS DEFINITION DEFERRED.
  CLASS LCL_EVENTS_SCREEN2 DEFINITION DEFERRED.
  CLASS LCL_EVENTS_button2 DEFINITION DEFERRED.

  DATA: GR_EVENTS         TYPE REF TO LCL_EVENTS,
        GR_EVENTS2        TYPE REF TO LCL_EVENTS_SCREEN2,
        GR_EVENTS_BUTTON2 TYPE REF TO LCL_EVENTS_BUTTON2.

  TYPES: BEGIN OF INT_TAB1_struct,
           KUNNR          TYPE VBAK-KUNNR,
           BILL_DOC       TYPE VBRP-VBELN,
           BELNR          TYPE BSID-BELNR,
           FKART          TYPE VBRK-FKART,
           TEXT_BILL_TYPE TYPE VBRK-FKART,
           NETWR          TYPE VBAP-NETWR,
           WAERK          TYPE VBAP-WERKS,
           TOTAL_AMT      TYPE VBAP-NETWR,
           SALES_CURR     TYPE VBAP-WERKS,
           TOTAL_QUANTITY TYPE VBAP-KWMENG,
           SALES_UNIT     TYPE VBAP-MEINS,
         END OF INT_TAB1_struct.
  DATA: INT_TAB1 TYPE TABLE OF INT_TAB1_struct.


CLASS LCL_EVENTS DEFINITION.
  PUBLIC SECTION.
    METHODS ON_CLICK FOR EVENT LINK_CLICK OF CL_SALV_EVENTS_TABLE
      IMPORTING
        ROW COLUMN.
ENDCLASS.
CLASS LCL_EVENTS_SCREEN2 DEFINITION.
  PUBLIC SECTION.
    METHODS ON_CLICK1 FOR EVENT LINK_CLICK OF CL_SALV_EVENTS_TABLE
      IMPORTING ROW COLUMN.
ENDCLASS.

CLASS LCL_EVENTS_BUTTON2 DEFINITION.
  PUBLIC SECTION.
    METHODS ON_CLICK1 FOR EVENT LINK_CLICK OF CL_SALV_EVENTS_TABLE
      IMPORTING ROW COLUMN.
    METHODS ON_CLICK_SCREEN2 FOR EVENT LINK_CLICK OF CL_SALV_EVENTS_TABLE
      IMPORTING ROW COLUMN.
ENDCLASS.



IF S1 = 'X'.

  SELECT
     FROM Z470_A21_BUTTON1( S_KUNNR_LOW = @S_KUNNR-LOW, S_KUNNR_HIGH = @S_KUNNR-HIGH  ) AS BUTTON1_V2
     FIELDS * INTO TABLE @DATA(ITAB1).



  SELECT
    FROM Z470_A21_BUTTON1( S_KUNNR_LOW = @S_KUNNR-LOW, S_KUNNR_HIGH = @S_KUNNR-HIGH  )\_V2 AS BUTTON1_V2
    FIELDS * INTO TABLE @DATA(ITAB2).





  SELECT
    FROM Z470_A21_BUTTON1( S_KUNNR_LOW = @S_KUNNR-LOW, S_KUNNR_HIGH = @S_KUNNR-HIGH  )\_V2\_ACCOUNT_DOC AS BUTTON1_V3
    FIELDS * INTO TABLE @DATA(ITAB3).




  IF SY-SUBRC IS INITIAL.
    TRY.
*1. GET ALV INSTANCE.
        CL_SALV_TABLE=>FACTORY(
          IMPORTING
            R_SALV_TABLE   = DATA(LO_ALV)
          CHANGING
            T_TABLE        = ITAB1[]
        ).

*2. GET COLUMNS FROM ALV INSTANCE
        LO_COLUMNS = LO_ALV->GET_COLUMNS( ).

*3. GET BUKRS COLUMN USING FIELD NAME FROM COLUMNS
        LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( COLUMNNAME = 'BILL_DOC' ).

*4. SET THE HOTSPOT FOR BUKRS COLUMN
        LO_COLUMN->SET_CELL_TYPE(
            VALUE = IF_SALV_C_CELL_TYPE=>HOTSPOT
        ).

*5. REGISTER EVENTS FOR ACTIONS
        DATA: LO_EVENTS TYPE REF TO CL_SALV_EVENTS_TABLE.

        LO_EVENTS = LO_ALV->GET_EVENT( ).

        CREATE OBJECT GR_EVENTS.

        SET HANDLER GR_EVENTS->ON_CLICK FOR LO_EVENTS.

        LO_ALV->SET_SCREEN_STATUS(
          EXPORTING
            REPORT        = 'SALV_TEST_FUNCTIONS'
            PFSTATUS      = 'SALV_STANDARD'
            SET_FUNCTIONS = LO_ALV->C_FUNCTIONS_ALL
          ).

*5. DIPLAY ALV OUTPUT
        LO_ALV->DISPLAY( ).

      CATCH CX_SALV_MSG.

    ENDTRY.

  ENDIF.


**---------------------------------------------------------------------------------------------------

ELSEIF S2 = 'X'.

*  data: out_tab1 type Z470_AMDP_A21=>OT1,
*      out_tab2 type Z470_AMDP_A21=>OT2,
*      out_tab3 type Z470_AMDP_A21=>OT3.
*
*  data(lt_obj) = new Z470_AMDP_A21( ).
*
*  LT_OBJ->GET_DATA1(
*  EXPORTING
*    S_LIFNR_LOW  = I_LFNR-LOW
*    S_LIFNR_HIGH = I_LFNR-HIGH
*  IMPORTING
*    RES1         = OUT_TAB1
*).

*types: BEGIN OF o_struct1,
*        lifnr type ekko-lifnr,
*         ebeln type ekko-ebeln,
*         matnr  type ekpo-matnr,
*         bwart type mseg-bwart,
*          mblnr type mseg-mblnr,
*          werks  type mseg-werks,
*          belnr type  rseg-belnr,
*         doc_type type c LENGTH 10 ,
*  end of o_struct1.

  TYPES: BEGIN OF O_STRUCT1,
           LIFNR        TYPE EKKO-LIFNR,
           EBELN        TYPE EKKO-EBELN,
           MATNR        TYPE EKPO-MATNR,
           NETWR        TYPE MSEG-DMBTR,
           WAERS        TYPE MSEG-WAERS,
           SUM_QUANTITY TYPE MSEG-DMBTR,
           MEINS        TYPE MSEG-MEINS,
           BWART        TYPE MSEG-BWART,
           MBLNR        TYPE MSEG-MBLNR,
           WERKS        TYPE MSEG-WERKS,
         END OF O_STRUCT1.
  TYPES: BEGIN OF O_STRUCT2,
           LIFNR      TYPE EKKO-LIFNR,
           EBELN      TYPE EKKO-EBELN,
           BELNR      TYPE MSEG-BELNR,
           MATNR      TYPE EKPO-MATNR,
           SUM_AMOUNT TYPE MSEG-DMBTR,
           WAERS      TYPE WAERS,
           BWART      TYPE MSEG-BWART,
           MBLNR      TYPE MSEG-MBLNR,
           WERKS      TYPE MSEG-WERKS,
         END OF O_STRUCT2.
  DATA: TT_TAB1 TYPE TABLE OF O_STRUCT2.
  DATA: OUT_TAB1 TYPE TABLE OF O_STRUCT1.

  SELECT * FROM Z470_A21_TABLE_FUNCTION( s_LIFNR_LOW = @I_LFNR-LOW , s_LIFNR_HIGH = @I_LFNR-HIGH ) INTO TABLE @DATA(TEMP_TAB).

  SELECT
    LIFNR,
    EBELN,
    MATNR,
    SUM_AMOUNT,
    WAERS,
    SUM_QUANTITY,
    MEINS,
    BWART,
    MBLNR,
    WERKS
    FROM @TEMP_TAB AS TB1 INTO TABLE @OUT_TAB1.

  SELECT
   LIFNR,
   EBELN,
   BELNR,
   MATNR,
   SUM_AMOUNT,
   WAERS,
   BWART,
   MBLNR,
   WERKS
   FROM @TEMP_TAB AS TB2 INTO TABLE @DATA(OUT_TAB2).

  SELECT
    LIFNR,
    EBELN,
    BELNR,
    MATNR,
    SUM_AMOUNT,
    WAERS,
    DOC_TYPE
    FROM @TEMP_TAB AS TB3 INTO TABLE @DATA(OUT_TAB3).




*  CL_DEMO_OUTPUT=>DISPLAY( OUT_TAB1 ).

  IF SY-SUBRC IS INITIAL.

    TRY.
        CL_SALV_TABLE=>FACTORY(
          IMPORTING
            R_SALV_TABLE   =  DATA(BUTTON2_OBJ)                         " Basis Class Simple ALV Tables
          CHANGING
            T_TABLE        =  OUT_TAB1[]
        ).
*    CATCH CX_SALV_MSG. " ALV: General Error Class with Message

        LO_COLUMNS = BUTTON2_OBJ->GET_COLUMNS( ).

        LO_COLUMN  ?=  LO_COLUMNS->GET_COLUMN( COLUMNNAME = 'EBELN' ).

        LO_COLUMN->SET_CELL_TYPE(
        VALUE = IF_SALV_C_CELL_TYPE=>HOTSPOT
        ).



        DATA: LO_EVENTS_BUTTON2 TYPE REF TO CL_SALV_EVENTS_TABLE.

        LO_EVENTS_BUTTON2 = BUTTON2_OBJ->GET_EVENT( ).

        CREATE OBJECT GR_EVENTS_BUTTON2.

        SET HANDLER GR_EVENTS_BUTTON2->ON_CLICK1 FOR LO_EVENTS_BUTTON2.

        BUTTON2_OBJ->SET_SCREEN_STATUS(
          REPORT        = 'SALV_TEST_FUNCTIONS'
          PFSTATUS      = 'SALV_STANDARD'
          SET_FUNCTIONS = BUTTON2_OBJ->C_FUNCTIONS_ALL
        ).

        BUTTON2_OBJ->DISPLAY( ).

      CATCH CX_SALV_MSG.
    ENDTRY.
  ENDIF.

ENDIF.

END-OF-SELECTION.


CLASS LCL_EVENTS IMPLEMENTATION.
  METHOD ON_CLICK.

    READ TABLE ITAB1 INTO DATA(WA_1) INDEX ROW.

    SELECT
      * FROM @ITAB2 AS B1_TAB1
      WHERE B1_TAB1~BILL_DOC = @WA_1-BILL_DOC
      INTO CORRESPONDING FIELDS OF TABLE @INT_TAB1.


    IF SY-SUBRC IS INITIAL.

*      CL_DEMO_OUTPUT=>DISPLAY( itab2 ).
      TRY.
          CL_SALV_TABLE=>FACTORY(
      IMPORTING
        R_SALV_TABLE   = DATA(LO_ALV1)
      CHANGING
        T_TABLE        = INT_TAB1[]
    ).


*2. GET COLUMNS FROM ALV INSTANCE
          LO_COLUMNS_1 = LO_ALV1->GET_COLUMNS( ).


*3. GET BUKRS COLUMN USING FIELD NAME FROM COLUMNS
          LO_COLUMN_1 ?= LO_COLUMNS_1->GET_COLUMN( COLUMNNAME = 'BELNR' ).



*4. SET THE HOTSPOT FOR BUKRS COLUMN
          LO_COLUMN_1->SET_CELL_TYPE(
              VALUE = IF_SALV_C_CELL_TYPE=>HOTSPOT
          ).


*5. REGISTER EVENTS FOR ACTIONS
          DATA: LO_EVENTS1 TYPE REF TO CL_SALV_EVENTS_TABLE.

          LO_EVENTS1 = LO_ALV1->GET_EVENT( ).

          CREATE OBJECT GR_EVENTS2.


          SET HANDLER GR_EVENTS2->ON_CLICK1 FOR LO_EVENTS1.

          LO_ALV->SET_SCREEN_STATUS(
            EXPORTING
              REPORT        = 'SALV_TEST_FUNCTIONS'
              PFSTATUS      = 'SALV_STANDARD'
              SET_FUNCTIONS = LO_ALV1->C_FUNCTIONS_ALL
            ).

*5. DIPLAY ALV OUTPUT
          LO_ALV1->DISPLAY( ).
        CATCH CX_SALV_MSG.
      ENDTRY.

    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS LCL_EVENTS_SCREEN2 IMPLEMENTATION.

  METHOD ON_CLICK1.

    READ TABLE INT_TAB1 INTO DATA(WA_2) INDEX ROW.

    IF SY-SUBRC IS INITIAL.

      SELECT
         * FROM @ITAB3 AS B1_TAB2
         WHERE B1_TAB2~BELNR = @WA_2-BELNR
         INTO TABLE @DATA(INT_TAB2).



*      CL_DEMO_OUTPUT=>DISPLAY( itab2 ).
      TRY.
          CL_SALV_TABLE=>FACTORY(
      IMPORTING
        R_SALV_TABLE   = DATA(LO_ALV2)
      CHANGING
        T_TABLE        = INT_TAB2[]
    ).
          LO_ALV2->DISPLAY( ).

        CATCH CX_SALV_MSG.

      ENDTRY.
    ENDIF.
  ENDMETHOD.


ENDCLASS.



**-------------------------------------------------------------------------------------


CLASS LCL_EVENTS_BUTTON2 IMPLEMENTATION.

  METHOD ON_CLICK1.

*   LT_OBJ->GET_DATA2(
*  EXPORTING
*    IN_TAB1 = OUT_TAB1
*  IMPORTING
*    RES2    = OUT_TAB2
*).
    READ TABLE OUT_TAB1 INTO DATA(TEMP_1) INDEX ROW.





    SELECT * FROM @OUT_TAB2 AS TEMP_TAB2
      WHERE TEMP_TAB2~EBELN = @TEMP_1-EBELN INTO CORRESPONDING FIELDS OF TABLE @TT_TAB1.



    IF SY-SUBRC IS INITIAL.

*      CL_DEMO_OUTPUT=>DISPLAY( itab2 ).
      TRY.
          CL_SALV_TABLE=>FACTORY(
      IMPORTING
        R_SALV_TABLE   = DATA(BUTTON2_OBJ_2)
      CHANGING
        T_TABLE        = TT_TAB1[]
    ).



*2. GET COLUMNS FROM ALV INSTANCE
          LO_COLUMNS_1 = BUTTON2_OBJ_2->GET_COLUMNS( ).


*3. GET BUKRS COLUMN USING FIELD NAME FROM COLUMNS
          LO_COLUMN_1 ?= LO_COLUMNS_1->GET_COLUMN( COLUMNNAME = 'BELNR' ).



*4. SET THE HOTSPOT FOR BUKRS COLUMN
          LO_COLUMN_1->SET_CELL_TYPE(
              VALUE = IF_SALV_C_CELL_TYPE=>HOTSPOT
          ).


*5. REGISTER EVENTS FOR ACTIONS
*      DATA: lo_events_button2_1 TYPE REF TO CL_SALV_EVENTS_TABLE.

          LO_EVENTS_BUTTON2 = BUTTON2_OBJ_2->GET_EVENT( ).

          SET HANDLER ME->ON_CLICK_SCREEN2 FOR LO_EVENTS_BUTTON2.

          BUTTON2_OBJ_2->SET_SCREEN_STATUS(
             EXPORTING
               REPORT        = 'SALV_TEST_FUNCTIONS'
               PFSTATUS      = 'SALV_STANDARD'
               SET_FUNCTIONS = BUTTON2_OBJ_2->C_FUNCTIONS_ALL
             ).

*5. DIPLAY ALV OUTPUT
          BUTTON2_OBJ_2->DISPLAY( ).
        CATCH CX_SALV_MSG.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD ON_CLICK_SCREEN2.

*  LT_OBJ->GET_DATA3(
*  EXPORTING
*    IN_TAB2 = OUT_TAB2
*  IMPORTING
*    RES3    = OUT_TAB3
*).


    READ TABLE TT_TAB1 INTO DATA(TEMP_2) INDEX ROW.

    TYPES: BEGIN OF O_STRUCT3,
             LIFNR      TYPE EKKO-LIFNR,
             EBELN      TYPE EKKO-EBELN,
             BELNR      TYPE MSEG-BELNR,
             MATNR      TYPE EKPO-MATNR,
             SUM_AMOUNT TYPE MSEG-DMBTR,
             WAERS      TYPE WAERS,
             DOC_TYPE   TYPE C LENGTH 10,
           END OF O_STRUCT3.
    DATA: TT_TAB2 TYPE TABLE OF O_STRUCT3.

    SELECT * FROM @OUT_TAB3 AS TEMP_TAB3
      WHERE TEMP_TAB3~BELNR = @TEMP_2-BELNR AND TEMP_TAB3~LIFNR = @TEMP_2-LIFNR INTO TABLE @TT_TAB2.


    IF SY-SUBRC = 0.

      TRY.
          CL_SALV_TABLE=>FACTORY(
      IMPORTING
        R_SALV_TABLE   = DATA(BUTTON2_final)
      CHANGING
        T_TABLE        = TT_TAB2[]
    ).
          BUTTON2_final->DISPLAY( ).
        CATCH CX_SALV_MSG.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
