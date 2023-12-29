# Stock on posting date
Stock on posting date (package: ZC8A009)

<img src="https://github.com/OlegBash599/ZC8A009/blob/main/version_label.svg"/>

Approaches how to read stock on posting date in SAP ERP:
1) via copy report. in [not-modern version](https://github.com/OlegBash599/ZC8A009/blob/main/src/zcl_c8a009_mb5b.clas.abap)
2) forever-stable version via SUBMIT...LIST TO MEMORY (with further calling function LIST_FROM_MEMORY ) (https://github.com/OlegBash599/ZC8A009/blob/main/src/zcl_c8a009_mb5b_via_spool.clas.abap)
3) via standard parameter for export to memory. in [modern version](https://github.com/OlegBash599/ZC8A009/blob/main/src/zcl_c8a009_mb5b_v2std.clas.abap)
4) via CDS-view in [HANA-version via CDS](https://github.com/OlegBash599/ZC8A009/blob/main/src/zcl_c8a009_stock_on_date_cds.clas.abap)
5) with help of Enhancement SPOT (https://sappro.sapland.ru/kb/articles/stats/rasshireniya-sistemi-enhancement-framework-chasti-2.html)


Blog is available [here](https://blogs.sap.com/2023/12/28/how-to-get-stock-on-posting-date-manually-and-programmatically/)
