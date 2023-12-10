CLASS zcl_c8a009_mb5b_via_spool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS read_stock_on_date
      IMPORTING
        !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      EXPORTING
        !et_stock        TYPE zttc8a009_mb5b_list_output .
    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_stock_output_string
            , empty_first TYPE string
            , val_area TYPE string
            , material TYPE string
            , from_date TYPE string
            , to_date TYPE string
            , opening_stock TYPE string
            , total_receipt_q TYPE string
            , total_issue_q TYPE string
            , closing_stock TYPE string
            , base_unit TYPE string
            , opening_value TYPE string
            , total_receipt_val TYPE string
            , total_issue_val TYPE string
            , closing_val TYPE string
            , currency TYPE string
         , END OF ts_stock_output_string .
    TYPES:
      tt_stock_output_string TYPE STANDARD TABLE OF ts_stock_output_string WITH DEFAULT KEY .
    TYPES ts_stock_data TYPE zsc8a009_mb5b_list_output .
    TYPES tt_stock_data TYPE zttc8a009_mb5b_list_output .

    DATA ms_logondata TYPE bapilogond.
    DATA ms_defaults TYPE  bapidefaul.

    DATA mt_t006a TYPE STANDARD TABLE OF t006a WITH DEFAULT KEY.

    METHODS _valid_input
      IMPORTING
        !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      RETURNING
        VALUE(rv_val)    TYPE abap_bool .
    METHODS _run_report
      IMPORTING
        !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria .
    METHODS _read_n_parse_memory_list
      EXPORTING !et_stock TYPE zttc8a009_mb5b_list_output.
    METHODS _read_list_into_string_tab
      EXPORTING
        !et_stock_string TYPE tt_stock_output_string .
    METHODS _parse_list2stock_line
      IMPORTING
        !is_stock_output TYPE ts_stock_output_string
      EXPORTING
        !es_stock_data   TYPE ts_stock_data .
    METHODS _parse_matnr
      IMPORTING
        !iv_str TYPE string
      EXPORTING
        !ev     TYPE matnr .
    METHODS _parse_qty
      IMPORTING
        !iv_qty_str TYPE string
      EXPORTING
        !ev         TYPE menge_d .
    METHODS _parse_amount
      IMPORTING
        !iv_amount_str TYPE string
      EXPORTING
        !ev            TYPE dmbtr .

    METHODS _parse_uom
      IMPORTING iv_uom_str TYPE string
      EXPORTING ev         TYPE meins.
ENDCLASS.



CLASS ZCL_C8A009_MB5B_VIA_SPOOL IMPLEMENTATION.


  METHOD constructor.


    DATA lt_ret2 TYPE bapirettab.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username  = sy-uname    " User Name
*       cache_results  = 'X'    " Temporarily buffer results in work process
      IMPORTING
        logondata = ms_logondata    " Structure with Logon Data
        defaults  = ms_defaults    " Structure with User Defaults
*       address   =     " Address Data
*       company   =     " Company for Company Address
*       snc       =     " Secure Network Communication Data
*       ref_user  =     " User Name of the Reference User
*       alias     =     " User Name Alias
*       uclass    =     " License-Related User Classification
*       lastmodified   =     " User: Last Change (Date and Time)
*       islocked  =     " User Lock
*       identity  =     " Person Assignment of an Identity
*       admindata =     " User: Administration Data
*       description    =     " Description
      TABLES
*       parameter =     " Table with User Parameters
*       profiles  =     " Profiles
*       activitygroups =     " Activity Groups
        return    = lt_ret2   " Return Structure
*       addtel    =     " BAPI Structure Telephone Numbers
*       addfax    =     " BAPI Structure Fax Numbers
*       addttx    =     " BAPI Structure Teletex Numbers
*       addtlx    =     " BAPI Structure Telex Numbers
*       addsmtp   =     " E-Mail Addresses BAPI Structure
*       addrml    =     " Inhouse Mail BAPI Structure
*       addx400   =     " BAPI Structure X400 Addresses
*       addrfc    =     " BAPI Structure RFC Addresses
*       addprt    =     " BAPI Structure Printer Addresses
*       addssf    =     " BAPI Structure SSF Addresses
*       adduri    =     " BAPI Structure: URL, FTP, and so on
*       addpag    =     " BAPI Structure Pager Numbers
*       addcomrem =     " BAPI Structure Communication Comments
*       parameter1     =     " Replaces Parameter (Length 18 -> 40)
*       groups    =     " Transfer Structure for a List of User Groups
*       uclasssys =     " System-Specific License-Related User Classification
*       extidhead =     " Header Data for External ID of a User
*       extidpart =     " Part of a Long Field for the External ID of a User
*       systems   =     " BAPI Structure for CUA Target Systems
      .
    """""""""""""""""""""

    SELECT * FROM t006a
        INTO TABLE mt_t006a
      UP TO 10000 ROWS
      WHERE spras = sy-langu

      .

    SORT mt_t006a BY mseh3.

  ENDMETHOD.


  METHOD read_stock_on_date.
    IF _valid_input( is_sel_criteria ) EQ abap_false.
      RETURN.
    ENDIF.

    _run_report( is_sel_criteria ).

    _read_n_parse_memory_list( IMPORTING et_stock = et_stock ).
  ENDMETHOD.


  METHOD _parse_amount.
    "IMPORTING iv_amount_str TYPE string
    "EXPORTING ev            TYPE DMBTR.
    DATA lv_str_in TYPE string.

    lv_str_in = iv_amount_str.
    CASE ms_defaults-dcpfm.
      WHEN 'X'.
      WHEN 'Y'.
      WHEN OTHERS.
        " 1.456.234,00
        REPLACE ALL OCCURRENCES OF '.' IN lv_str_in WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN lv_str_in WITH '.'.
        CONDENSE lv_str_in NO-GAPS.
    ENDCASE.

    CONDENSE lv_str_in NO-GAPS.

    ev = lv_str_in.
  ENDMETHOD.


  METHOD _parse_list2stock_line.
    "   IMPORTING is_stock_output TYPE ts_stock_output_string
    "   EXPORTING es_stock_data   TYPE ts_stock_data.

    CLEAR es_stock_data.

    es_stock_data-bwkey = is_stock_output-val_area.
    es_stock_data-werks = is_stock_output-val_area.

    "es_stock_data-matnr = is_stock_output-material.
    _parse_matnr( EXPORTING iv_str = is_stock_output-material
                  IMPORTING ev = es_stock_data-matnr ).
    "es_stock_data-CHARG 1 Types CHARG_D CHAR  10  0 Batch Number

    "es_stock_data-endmenge = is_stock_output-closing_stock.
    _parse_qty( EXPORTING iv_qty_str = is_stock_output-closing_stock
                IMPORTING ev = es_stock_data-endmenge ).

    "    es_stock_data-anfmenge  = is_stock_output-opening_stock.
    _parse_qty( EXPORTING iv_qty_str = is_stock_output-opening_stock
                IMPORTING ev = es_stock_data-anfmenge ).

    " es_stock_data-meins  = is_stock_output-base_unit.
    _parse_uom( EXPORTING iv_uom_str = is_stock_output-base_unit
                IMPORTING ev = es_stock_data-meins ).

    "  es_stock_data-endwert = is_stock_output-closing_val.
    _parse_amount( EXPORTING iv_amount_str = is_stock_output-closing_val
                   IMPORTING ev            = es_stock_data-endwert ).

    "  es_stock_data-anfwert = is_stock_output-opening_value.
    _parse_amount( EXPORTING iv_amount_str = is_stock_output-opening_value
                   IMPORTING ev            = es_stock_data-endwert ).

    " es_stock_data-soll = is_stock_output-total_receipt_q.
    _parse_qty( EXPORTING iv_qty_str = is_stock_output-total_receipt_q
                IMPORTING ev = es_stock_data-soll ).


    "es_stock_data-haben = is_stock_output-total_issue_q.
    _parse_qty( EXPORTING iv_qty_str = is_stock_output-total_issue_q
                IMPORTING ev = es_stock_data-haben ).


    "es_stock_data-sollwert = is_stock_output-total_receipt_val.
    _parse_amount( EXPORTING iv_amount_str = is_stock_output-total_receipt_val
                   IMPORTING ev            = es_stock_data-sollwert ).

    "es_stock_data-habenwert = is_stock_output-total_issue_val.
    _parse_amount( EXPORTING iv_amount_str = is_stock_output-total_issue_val
                   IMPORTING ev            = es_stock_data-habenwert ).

    es_stock_data-waers = is_stock_output-currency.

  ENDMETHOD.


  METHOD _parse_matnr.
    "IMPORTING iv_str TYPE string
    "EXPORTING ev     TYPE matnr.
    DATA lv_str_in TYPE string.

    lv_str_in = iv_str.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = iv_str
      IMPORTING
        output       = ev
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO sy-msgli.
      CLEAR ev.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD _parse_qty.
    "IMPORTING iv_qty_str TYPE string
    "EXPORTING ev     TYPE matnr.
    DATA lv_str_in TYPE string.

    lv_str_in = iv_qty_str.

    CASE ms_defaults-dcpfm.
      WHEN 'X'.
      WHEN 'Y'.
      WHEN OTHERS.
        " 1.456.234,00
        REPLACE ALL OCCURRENCES OF '.' IN lv_str_in WITH ''.
        REPLACE ALL OCCURRENCES OF ',' IN lv_str_in WITH '.'.
        CONDENSE lv_str_in NO-GAPS.
    ENDCASE.



    ev = lv_str_in.

  ENDMETHOD.


  METHOD _parse_uom.
    "IMPORTING iv_uom_str TYPE string
    "EXPORTING ev         TYPE meins.
    DATA lv_str_in TYPE string.

    FIELD-SYMBOLS <fs_t006a> TYPE t006a.

    lv_str_in = iv_uom_str.
    CONDENSE lv_str_in NO-GAPS.

    READ TABLE mt_t006a ASSIGNING <fs_t006a> WITH KEY mseh3 = lv_str_in BINARY SEARCH.
    IF sy-subrc EQ 0.
      ev = <fs_t006a>-msehi.
    ENDIF.

  ENDMETHOD.


  METHOD _read_list_into_string_tab.
    " EXPORTING et_stock_string TYPE tt_stock_output_string.
    TYPES: BEGIN OF ts_stock_ascii
          , line TYPE c LENGTH 1024
       , END OF ts_stock_ascii
       , tt_stock_ascii TYPE STANDARD TABLE OF ts_stock_ascii WITH DEFAULT KEY
       .

    DATA lt_stock_listascii TYPE tt_stock_ascii.

    DATA lt_abaplist TYPE table_abaplist.
    DATA lt_list_str_tab    TYPE list_string_table.
    DATA ls_stock_string TYPE ts_stock_output_string.
    DATA lv_from_line TYPE syindex.
    DATA lv_upto_line TYPE syindex.

    FIELD-SYMBOLS <fs_stock_listascii> TYPE ts_stock_ascii.

    CALL FUNCTION 'LIST_FROM_MEMORY'
      TABLES
        listobject = lt_abaplist
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO sy-msgli.
      RETURN.
    ENDIF.


    CALL FUNCTION 'LIST_TO_ASCI'
*      EXPORTING
*        list_index         = -1    " List level
*        with_line_break    = SPACE    " Use line breaks for overly long lines?
      IMPORTING
        list_string_ascii  = lt_list_str_tab    " Table Type for FB LIST_TO_ASCI
*       list_dyn_ascii     =     " Table with Generic Width
      TABLES
        listasci           = lt_stock_listascii    " Table for Receiving List (ASCI)
        listobject         = lt_abaplist    " Container for list object
      EXCEPTIONS
        empty_list         = 1
        list_index_invalid = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO sy-msgli.
      CLEAR lt_stock_listascii.
    ENDIF.

    " parse
    CLEAR et_stock_string.
    lv_from_line = 4.
    lv_upto_line = lines( lt_stock_listascii ) - 1.
    LOOP AT lt_stock_listascii ASSIGNING <fs_stock_listascii> FROM lv_from_line TO lv_upto_line.
      IF <fs_stock_listascii>-line CS '----------'.
        CONTINUE.
      ENDIF.
      CLEAR ls_stock_string.
      SPLIT <fs_stock_listascii>-line AT '|' INTO: ls_stock_string-empty_first
                                                   ls_stock_string-val_area
                                                   ls_stock_string-material
                                                   ls_stock_string-from_date
                                                   ls_stock_string-to_date
                                                   ls_stock_string-opening_stock
                                                   ls_stock_string-total_receipt_q
                                                   ls_stock_string-total_issue_q
                                                   ls_stock_string-closing_stock
                                                   ls_stock_string-base_unit
                                                   ls_stock_string-opening_value
                                                   ls_stock_string-total_receipt_val
                                                   ls_stock_string-total_issue_val
                                                   ls_stock_string-closing_val
                                                   ls_stock_string-currency
      .
      APPEND ls_stock_string TO et_stock_string.
    ENDLOOP.


    CALL FUNCTION 'LIST_FREE_MEMORY'
      TABLES
        listobject = lt_abaplist.    " Deletes container for list object


  ENDMETHOD.


  METHOD _read_n_parse_memory_list.

    DATA lt_stock TYPE zttc8a009_mb5b_list_output.
    DATA ls_stock_data TYPE zsc8a009_mb5b_list_output.

    DATA lt_output_string TYPE tt_stock_output_string.
    FIELD-SYMBOLS <fs_list_output> TYPE ts_stock_output_string.

    _read_list_into_string_tab( IMPORTING et_stock_string = lt_output_string ).

    LOOP AT lt_output_string ASSIGNING <fs_list_output>.

      _parse_list2stock_line( EXPORTING is_stock_output = <fs_list_output>
                              IMPORTING es_stock_data = ls_stock_data ).

      IF ls_stock_data IS NOT INITIAL.
        APPEND ls_stock_data TO lt_stock.
      ENDIF.

    ENDLOOP.

    et_stock = lt_stock.
  ENDMETHOD.


  METHOD _run_report.
    "IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria.
    DATA lt_rng_bukrs TYPE RANGE OF bukrs.
    DATA ls_rng_bukrs LIKE LINE OF lt_rng_bukrs.

    ls_rng_bukrs = 'IEQ'.
    ls_rng_bukrs-low = is_sel_criteria-bukrs.
    APPEND ls_rng_bukrs TO lt_rng_bukrs.

    SUBMIT rm07mlbd EXPORTING LIST TO MEMORY
                     WITH bukrs IN lt_rng_bukrs
                     WITH werks IN is_sel_criteria-werks_rng
                     WITH lgort IN is_sel_criteria-lgort_rng
                     WITH matnr IN is_sel_criteria-matnr_rng
                     WITH budat IN is_sel_criteria-budat_rng

                     WITH bwbst EQ abap_true " valuated stock
                     WITH pa_sumfl EQ abap_true " Non-Hierarchical
                     WITH pa_wdzer EQ abap_true " without opening stock; without closing stock (mat withno movemetns)

                     AND RETURN
                     .
  ENDMETHOD.


  METHOD _valid_input.
    "RETURNING VALUE(rv_val) TYPE abap_bool.
    rv_val = abap_false.
    IF is_sel_criteria IS INITIAL.
      MESSAGE s000(cl) WITH 'Not enough sel.criteria'.
      RETURN.
    ENDIF.

    IF is_sel_criteria-bukrs IS INITIAL.
      MESSAGE s000(cl) WITH 'Company Code must be filled'.
      RETURN.
    ENDIF.

    rv_val = abap_true.
  ENDMETHOD.
ENDCLASS.
