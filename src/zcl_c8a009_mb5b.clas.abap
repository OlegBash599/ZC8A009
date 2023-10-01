class ZCL_C8A009_MB5B definition
  public
  create public .

public section.

  methods CONSTRUCTOR .
  methods EXPORT2MEM
    importing
      !IT_BESTAND type ANY TABLE .
  methods READ_STOCK_ON_DATE
    exporting
      !ET_STOCK type ZTTC8A009_MB5B_LIST_OUTPUT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_C8A009_MB5B IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.


  METHOD export2mem.

    FIELD-SYMBOLS <fs_bestand_stock_line> type any.

    LOOP AT it_bestand ASSIGNING <fs_bestand_stock_line>.

    ENDLOOP.


  ENDMETHOD.


  method READ_STOCK_ON_DATE.



  endmethod.
ENDCLASS.
