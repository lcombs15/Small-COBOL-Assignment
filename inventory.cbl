IDENTIFICATION DIVISION.
PROGRAM-ID.  "NKU CSC407 OLDIE ASSIGNMENT".

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SOURCE-COMPUTER. LUCAS-UBUNTU.
OBJECT-COMPUTER. LUCAS-UBUNTU.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
	SELECT INV-FILE ASSIGN TO "data_files/inventory.dat".
	SELECT CUST-FILE ASSIGN TO "data_files/customers.dat".
	SELECT TRANS-FILE ASSIGN TO "data_files/transactions.dat".
	SELECT ERROR-FILE ASSIGN TO "data_files/errors.dat".
	SELECT TRANS-OUTPUT-FILE ASSIGN TO "data_files/transactions_processed.dat".
	SELECT INV-ORDER-FILE ASSIGN TO "data_files/inventory_order.dat".
DATA DIVISION.
FILE SECTION.
FD INV-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 55 CHARACTERS.

01 INVENTORY-RECORD.
	02 INV-ITEM-NO			PICTURE IS 9(6).
	02 FILLER			PICTURE IS X(5).
	02 INV-ITEM-NAME		PICTURE IS X(25).
	02 INV-QTY			PICTURE IS 9(2).
	02 FILLER			PICTURE IS X(5).
	02 INV-REORDER-PT		PICTURE IS 9(2).
	02 FILLER			PICTURE IS X(5).
	02 INV-PRICE			PICTURE IS 99V99.

FD CUST-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 87 CHARACTERS.

01 CUSTOMER-RECORD.
	02 CUST-NO		PICTURE IS 9(5).
	02 FILLER		PICTURE IS X(5).
	02 CUST-NAME		PICTURE IS X(23).
	02 CUST-STREET		PICTURE IS X(23).
	02 CUST-CITY		PICTURE IS X(13).
	02 CUST-REGION		PICTURE IS X(12).
	02 CUST-PAST-DUE	PICTURE IS 999V99.

FD TRANS-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 29 CHARACTERS.

01 TRANSACTION-RECORD.
	02 TRANS-CUST-NO	PICTURE IS 9(5).
	02 FILLER		PICTURE IS X(5).
	02 TRANS-ITEM-NO	PICTURE IS 9(6).
	02 FILLER		PICTURE IS X(6).
	02 TRANS-QTY-ORD	PICTURE IS 9.
	02 FILLER		PICTURE IS X(5).
	02 TRANS-CODE		PICTURE IS X.

FD ERROR-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 52 CHARACTERS.

01 ERROR-RECORD.
	02 ERROR-CUST-NO	PICTURE IS 9(5).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-ITEM-NO	PICTURE IS 9(6).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-QTY-ORD	PICTURE IS 9(1).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-CODE		PICTURE IS X(25).

FD TRANS-OUTPUT-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 138 CHARACTERS.

01 TRANS-OUTPUT-RECORD.
	02 TP-CUST-NAME			PICTURE IS X(23).
	02 TP-CUST-STREET		PICTURE IS X(23).
	02 TP-CUST-CITY			PICTURE IS X(13).
	02 TP-CUST-REGION		PICTURE IS X(12).
	02 TP-INV-ITEM-NAME		PICTURE IS X(25).
	02 TP-INV-QTY			PICTURE IS 9(2).
	02 FILLER			PICTURE IS X(5).
	02 TP-GROSS-COST		PICTURE IS 99V99.
	02 FILLER			PICTURE IS X(5).
	02 TP-DISCOUNT			PICTURE IS 99V99.
	02 FILLER			PICTURE IS X(5).
	02 TP-NETCOST			PICTURE IS 99V99.
	02 FILLER			PICTURE IS X(5).
	02 TP-CUST-BALANCE		PICTURE IS 99V99.

FD INV-ORDER-FILE
	LABEL RECORDS ARE STANDARD
	RECORD CONTAINS 14 CHARACTERS.

01 INV-ORDER-RECORD.
	02 ORDER-ITEM-NO		PICTURE IS X(6).
	02 FILLER			PICTURE IS X(6).
	02 ORDER-QTY			PICTURE IS 9(2).

WORKING-STORAGE SECTION.
01 SWITCHES.
	02 TRANS-EOF-SWITCH	PICTURE IS X(1) VALUE 'N'.
	02 INV-EOF-SWITCH	PICTURE IS X(1) VALUE 'N'.
	02 CUST-EOF-SWITCH	PICTURE IS X(1) VALUE 'N'.
	02 CUST-FOUND-FLAG	PICTURE IS X(1) VALUE 'N'.
	02 ITEM-FOUND-FLAG	PICTURE IS X(1) VALUE 'N'.
01 WS-CUST-TABLE.
	02 WS-CUST-DETAILS OCCURS 10 TIMES INDEXED BY CUST-INDEX.
		03 WS-CUST-NO		PICTURE IS 9(5).
		03 WS-CUST-NAME		PICTURE IS X(23).
        	03 WS-CUST-STREET	PICTURE IS X(23).
		03 WS-CUST-CITY		PICTURE IS X(13).
		03 WS-CUST-REGION	PICTURE IS X(12).
		03 WS-CUST-PAST-DUE	PICTURE IS 999V99.

01 NUM-IN	PICTURE IS 99 VALUE 0.

01 WS-INVENTORY-TABLE.
	02 WS-INV-DETAILS OCCURS 24 TIMES INDEXED BY INV-INDEX.
		03 WS-INV-ITEM-NO		PICTURE IS 9(6).
		03 WS-INV-ITEM-NAME		PICTURE IS X(25).
		03 WS-INV-QTY			PICTURE IS 9(2).
		03 WS-INV-REORDER-PT		PICTURE IS 9(2).
		03 WS-INV-PRICE			PICTURE IS 99V99.

PROCEDURE DIVISION.
000-FULFILL-ORDERS.
	OPEN INPUT INV-FILE.
	PERFORM 010-IMPORT-INVENTORY.
	CLOSE INV-FILE.
	
	OPEN INPUT CUST-FILE.
	MOVE 0 TO NUM-IN.
	PERFORM 020-IMPORT-CUSTOMERS.
	CLOSE CUST-FILE.
	
	OPEN INPUT TRANS-FILE.
	PERFORM 030-PROCESS-TRANSACTION
		UNTIL TRANS-EOF-SWITCH IS EQUAL TO "Y".
	CLOSE TRANS-FILE.
	STOP RUN.

010-IMPORT-INVENTORY.
	READ INV-FILE INTO INVENTORY-RECORD
		AT END MOVE "Y" TO INV-EOF-SWITCH.
	PERFORM
		011-PROCESS-INV-RECORD.

011-PROCESS-INV-RECORD.
	ADD 1 TO NUM-IN.
	MOVE INV-ITEM-NO TO WS-INV-ITEM-NO(NUM-IN)
	MOVE INV-ITEM-NAME TO WS-INV-ITEM-NAME(NUM-IN)
	MOVE INV-QTY TO WS-INV-QTY(NUM-IN)
	MOVE INV-REORDER-PT TO WS-INV-REORDER-PT(NUM-IN)
	READ INV-FILE INTO INVENTORY-RECORD
		AT END MOVE "Y" TO INV-EOF-SWITCH.

020-IMPORT-CUSTOMERS.
	READ CUST-FILE INTO CUSTOMER-RECORD
		AT END MOVE "Y" TO CUST-EOF-SWITCH.
	PERFORM
		021-PROCESS-CUST-RECORD.

021-PROCESS-CUST-RECORD.
	ADD 1 TO NUM-IN.	
		MOVE CUST-NO TO WS-CUST-NO(NUM-IN)
		MOVE CUST-NAME TO WS-CUST-NAME(NUM-IN)
        	MOVE CUST-STREET TO WS-CUST-STREET(NUM-IN)
		MOVE CUST-CITY TO WS-CUST-CITY(NUM-IN)
		MOVE CUST-REGION TO WS-CUST-REGION(NUM-IN)
		MOVE CUST-PAST-DUE TO WS-CUST-PAST-DUE(NUM-IN)
	READ CUST-FILE INTO CUSTOMER-RECORD
		AT END MOVE "Y" TO CUST-EOF-SWITCH.

030-PROCESS-TRANSACTION.	
	READ TRANS-FILE INTO TRANSACTION-RECORD
		AT END MOVE "Y" TO TRANS-EOF-SWITCH.
	PERFORM
		031-PROCESS-TRANS-RECORD.

031-PROCESS-TRANS-RECORD.
	SET CUST-INDEX to 0.
	SEARCH WS-CUST-DETAILS
		AT END DISPLAY "Invalid Customer"
		WHEN WS-CUST-NO(CUST-INDEX) = TRANS-CUST-NO
			DISPLAY "Customer Found"
	END-SEARCH.
	
	SET INV-INDEX to 1.
	SEARCH WS-INV-DETAILS
		AT END DISPLAY "Invalid Item"
		WHEN WS-INV-ITEM-NO(INV-INDEX) = TRANS-ITEM-NO
			DISPLAY "Item Found"
	END-SEARCH.
