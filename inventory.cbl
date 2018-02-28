IDENTIFICATION DIVISION.
PROGRAM-ID.  "NKU CSC407 OLDIE ASSIGNMENT".

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SOURCE-COMPUTER. LUCAS-UBUNTU.
OBJECT-COMPUTER. LUCAS-UBUNTU.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
	SELECT INV-FILE ASSIGN TO "data_files/inventory.dat"
		ORGANIZATION IS LINE SEQUENTIAL.
	SELECT CUST-FILE ASSIGN TO "data_files/customers.dat"
		ORGANIZATION IS LINE SEQUENTIAL.
	SELECT TRANS-FILE ASSIGN TO "data_files/transactions.dat"
		ORGANIZATION IS LINE SEQUENTIAL.
	SELECT ERROR-FILE ASSIGN TO "data_files/errors.dat"
		ORGANIZATION IS LINE SEQUENTIAL.
	SELECT TRANS-OUTPUT-FILE ASSIGN TO "data_files/transactions_processed.dat"
		ORGANIZATION IS LINE SEQUENTIAL.
	SELECT INV-ORDER-FILE ASSIGN TO "data_files/inventory_order.dat"
		ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD INV-FILE
	LABEL RECORDS ARE STANDARD.

01 INV-RECORD.
	02 INV-ITEM-NO			PICTURE IS X(6).
	02 FILLER			PICTURE IS X(5).
	02 INV-ITEM-NAME		PICTURE IS X(25).
	02 INV-QTY			PICTURE IS 9(2).
	02 FILLER			PICTURE IS X(5).
	02 INV-REORDER-PT		PICTURE IS 9(2).
	02 FILLER			PICTURE IS X(5).
	02 INV-PRICE			PICTURE IS 99.99.

FD CUST-FILE
	LABEL RECORDS ARE STANDARD.

01 CUST-RECORD.
	02 CUST-NO		PICTURE IS X(5).
	02 FILLER		PICTURE IS X(5).
	02 CUST-NAME		PICTURE IS X(23).
	02 CUST-STREET		PICTURE IS X(23).
	02 CUST-CITY		PICTURE IS X(13).
	02 CUST-REGION		PICTURE IS X(12).
	02 CUST-PAST-DUE	PICTURE IS 999.99.

FD TRANS-FILE
	LABEL RECORDS ARE STANDARD.

01 TRANS-RECORD.
	02 TRANS-CUST-NO	PICTURE IS X(5).
	02 FILLER		PICTURE IS X(5).
	02 TRANS-ITEM-NO	PICTURE IS 9(6).
	02 FILLER		PICTURE IS X(6).
	02 TRANS-QTY-ORD	PICTURE IS 9.
	02 FILLER		PICTURE IS X(5).
	02 TRANS-CODE		PICTURE IS X.

FD ERROR-FILE
	LABEL RECORDS ARE STANDARD.

01 ERROR-RECORD.
	02 ERROR-CUST-NO	PICTURE IS 9(5).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-ITEM-NO	PICTURE IS 9(6).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-QTY-ORD	PICTURE IS 9(1).
	02 FILLER		PICTURE IS X(5).
	02 ERROR-CODE		PICTURE IS X(25).

FD TRANS-OUTPUT-FILE
        LABEL RECORDS ARE STANDARD.

01 TRANS-OUTPUT-RECORD.
	02 TP-CUST-NAME                 PICTURE IS X(23).
	02 TP-CUST-STREET               PICTURE IS X(23).
	02 TP-CUST-CITY                 PICTURE IS X(13).
	02 TP-CUST-REGION               PICTURE IS X(12).
	02 TP-INV-ITEM-NAME             PICTURE IS X(25).
	02 TP-INV-QTY                   PICTURE IS 9(2).
	02 FILLER                       PICTURE IS X(5).
	02 TP-GROSS-COST                PICTURE IS 9999V99.
	02 FILLER                       PICTURE IS X(5).
	02 TP-DISCOUNT                  PICTURE IS 9999V99.
	02 FILLER                       PICTURE IS X(5).
	02 TP-NETCOST                   PICTURE IS 9999V99.
	02 FILLER                       PICTURE IS X(5).
	02 TP-CUST-BALANCE              PICTURE IS 9999V99.

FD INV-ORDER-FILE
	LABEL RECORDS ARE STANDARD.

01 INV-ORDER-RECORD.
	02 ORDER-ITEM-NO                PICTURE IS X(6).
	02 FILLER                       PICTURE IS X(6).
	02 ORDER-QTY                    PICTURE IS 9(2).



WORKING-STORAGE SECTION.
01 SWITCHES.
	02 INV-EOF-SWITCH	PICTURE IS X(1) VALUE IS 'N'.
	02 CUST-EOF-SWITCH	PICTURE IS X(1) VALUE IS 'N'.
	02 TRANS-EOF-SWITCH	PICTURE IS X(1) VALUE IS 'N'.
	02 CUST-FOUND-FLAG	PICTURE IS X(1) VALUE IS 'N'.
	02 INV-FOUND-FLAG	PICTURE IS X(1) VALUE IS 'N'.

01 WS-INV-TABLE.
	02 WS-INV-DETAIL OCCURS 24 TIMES INDEXED BY INV-INDEX.
		03 WS-INV-ITEM-NO		PICTURE IS X(6).
		03 WS-INV-ITEM-NAME		PICTURE IS X(25).
		03 WS-INV-QTY			PICTURE IS 9(2).
		03 WS-INV-REORDER-PT		PICTURE IS 9(2).
		03 WS-INV-PRICE			PICTURE IS S9(2)V9(2).

01 WS-CUST-TABLE.
	02 WS-CUST-DETAIL OCCURS 10 TIMES INDEXED BY CUST-INDEX.
		03 WS-CUST-NO		PICTURE IS 9(5).
		03 WS-CUST-NAME		PICTURE IS X(23).
		03 WS-CUST-STREET	PICTURE IS X(23).
		03 WS-CUST-CITY		PICTURE IS X(13).
		03 WS-CUST-REGION	PICTURE IS X(12).
		03 WS-CUST-PAST-DUE	PICTURE IS S9(3)V9(2).

01 WORK-FIELDS.
	02 INV-NUM-IN		PIC S9(5) VALUE 0.
	02 CUST-NUM-IN		PIC S9(5) VALUE 0.


PROCEDURE DIVISION.
000-FULFILL-ORDERS.
	PERFORM 010-IMPORT-INVENTORY.
	PERFORM 020-IMPORT-CUSTOMER.
	PERFORM 030-READ-TRANSACTIONS.
	STOP RUN.
	
010-IMPORT-INVENTORY.
	OPEN INPUT INV-FILE.
	PERFORM UNTIL INV-EOF-SWITCH IS EQUAL TO 'Y'
		READ INV-FILE INTO INV-RECORD
			AT END
				MOVE 'Y' TO INV-EOF-SWITCH
			NOT AT END
				ADD 1 TO INV-NUM-IN
				MOVE INV-ITEM-NO TO WS-INV-ITEM-NO(INV-NUM-IN)
				MOVE INV-ITEM-NAME TO WS-INV-ITEM-NAME(INV-NUM-IN)
				MOVE INV-QTY TO WS-INV-QTY(INV-NUM-IN)
				MOVE INV-REORDER-PT TO WS-INV-REORDER-PT(INV-NUM-IN)
				MOVE INV-PRICE TO WS-INV-PRICE(INV-NUM-IN)
		END-READ
	END-PERFORM.
	CLOSE INV-FILE.

020-IMPORT-CUSTOMER.
	OPEN INPUT CUST-FILE.
	PERFORM UNTIL CUST-EOF-SWITCH IS EQUAL TO 'Y'
		READ CUST-FILE INTO CUST-RECORD
			AT END
				MOVE 'Y' TO CUST-EOF-SWITCH
			NOT AT END
				ADD 1 TO CUST-NUM-IN
				MOVE CUST-NO TO WS-CUST-NO(CUST-NUM-IN)
				MOVE CUST-NAME TO WS-CUST-NAME(CUST-NUM-IN)
				MOVE CUST-STREET TO WS-CUST-STREET(CUST-NUM-IN)
				MOVE CUST-CITY TO WS-CUST-CITY(CUST-NUM-IN)
				MOVE CUST-REGION TO WS-CUST-REGION(CUST-NUM-IN)
				MOVE CUST-PAST-DUE TO WS-CUST-PAST-DUE(CUST-NUM-IN)
		END-READ
	END-PERFORM.
	CLOSE CUST-FILE.

030-READ-TRANSACTIONS.
	OPEN INPUT TRANS-FILE.
        OPEN OUTPUT ERROR-FILE.
           OPEN OUTPUT INV-ORDER-FILE.
           OPEN OUTPUT TRANS-OUTPUT-FILE.

	PERFORM UNTIL TRANS-EOF-SWITCH IS EQUAL TO 'Y'
		READ TRANS-FILE INTO TRANS-RECORD
		AT END
			MOVE 'Y' TO TRANS-EOF-SWITCH
		NOT AT END
                        PERFORM 031-PROCESS-TRANSACTION
                
                        END-PERFORM.
           
	CLOSE TRANS-FILE.
        CLOSE ERROR-FILE.
           CLOSE INV-ORDER-FILE.
           CLOSE TRANS-OUTPUT-FILE.

031-PROCESS-TRANSACTION.
	MOVE SPACE TO ERROR-RECORD.
	PERFORM 032-CUST-NO-SEARCH.
	IF CUST-FOUND-FLAG IS EQUAL TO "N" THEN
		MOVE 'INVALID CUSTOMER NO' TO ERROR-CODE
                PERFORM 040-LOG-ERROR
	ELSE 
		PERFORM 033-ITEM-NO-SEARCH
		IF INV-FOUND-FLAG IS EQUAL TO "N" THEN
			MOVE 'INVALID PRODUCT NO' TO ERROR-CODE
			PERFORM 040-LOG-ERROR
		ELSE
                        PERFORM 050-COMPUTE-TRANSACTION
		END-IF
	END-IF.

032-CUST-NO-SEARCH.
	MOVE 'N' TO CUST-FOUND-FLAG.
	SET CUST-INDEX TO 1.
	SEARCH WS-CUST-DETAIL
                WHEN WS-CUST-NO(CUST-INDEX) = TRANS-CUST-NO
			MOVE "Y" TO CUST-FOUND-FLAG
	END-SEARCH.

033-ITEM-NO-SEARCH.
	MOVE 'N' TO INV-FOUND-FLAG.
	SET INV-INDEX to 1.
	SEARCH WS-INV-DETAIL
		WHEN WS-INV-ITEM-NO(INV-INDEX) = TRANS-ITEM-NO
			MOVE "Y" TO INV-FOUND-FLAG
	END-SEARCH.

040-LOG-ERROR.
	MOVE TRANS-CUST-NO TO ERROR-CUST-NO.
	MOVE TRANS-ITEM-NO TO ERROR-ITEM-NO.
	MOVE TRANS-QTY-ORD TO ERROR-QTY-ORD.
	WRITE ERROR-RECORD.

050-COMPUTE-TRANSACTION.
	MULTIPLY TRANS-QTY-ORD BY WS-INV-PRICE(INV-INDEX) GIVING TP-GROSS-COST.
           PERFORM 051-CALCULATE-DISCOUNT.
           SUBTRACT TP-DISCOUNT FROM TP-GROSS-COST GIVING TP-NETCOST.
           PERFORM 052-UPDATE-CUST-TABLE.
           PERFORM 053-UPDATE-INV-TABLE.
           PERFORM 070-CHECK-REORDER.
           PERFORM 080-LOG-TRANS.


051-CALCULATE-DISCOUNT.
	IF TRANS-CODE IS EQUAL TO "A" THEN
		MULTIPLY TP-GROSS-COST BY 0.1 GIVING TP-DISCOUNT
	ELSE IF TRANS-CODE IS EQUAL TO "B" THEN
		MULTIPLY TP-GROSS-COST BY 0.2 GIVING TP-DISCOUNT
	ELSE IF TRANS-CODE IS EQUAL TO "C" THEN
		MULTIPLY TP-GROSS-COST BY 0.25 GIVING TP-DISCOUNT
	ELSE IF TRANS-CODE IS EQUAL TO "D" THEN
		IF TRANS-QTY-ORD IS GREATER THAN 2 THEN
                        SET TP-DISCOUNT TO  WS-INV-PRICE(INV-INDEX)
                END-IF
        ELSE IF TRANS-CODE IS EQUAL TO "E" THEN
		MULTIPLY TP-GROSS-COST BY 0.5 GIVING TP-DISCOUNT
	ELSE
		MOVE 0 TO TP-DISCOUNT
           END-IF.

052-UPDATE-CUST-TABLE.
           ADD TP-NETCOST TO WS-CUST-PAST-DUE(CUST-INDEX) GIVING
           WS-CUST-PAST-DUE(CUST-INDEX).

053-UPDATE-INV-TABLE.
           SUBTRACT TRANS-QTY-ORD FROM WS-INV-QTY(INV-INDEX) GIVING
           WS-INV-QTY(INV-INDEX).



           
070-CHECK-REORDER.
           MOVE SPACE TO INV-ORDER-RECORD.   
           MOVE ZERO TO ORDER-QTY.
           IF WS-INV-QTY(INV-INDEX) <= WS-INV-REORDER-PT(INV-INDEX) THEN
                   DISPLAY 'NEED TO REODER'
                   DISPLAY WS-INV-QTY(INV-INDEX)
                   DISPLAY WS-INV-REORDER-PT(INV-INDEX)
		IF WS-INV-REORDER-PT(INV-INDEX) EQUAL TO 1 THEN
			SUBTRACT WS-INV-QTY(INV-INDEX) FROM 3 GIVING ORDER-QTY
		ELSE IF WS-INV-REORDER-PT(INV-INDEX) IS LESS THAN 6 THEN
			SUBTRACT WS-INV-QTY(INV-INDEX) FROM 6 GIVING ORDER-QTY
		ELSE IF WS-INV-REORDER-PT(INV-INDEX) IS LESS THAN 11 THEN
			SUBTRACT WS-INV-QTY(INV-INDEX) FROM 12 GIVING ORDER-QTY
		ELSE IF WS-INV-REORDER-PT(INV-INDEX) IS LESS THAN 21 THEN
			SUBTRACT WS-INV-QTY(INV-INDEX) FROM 25 GIVING ORDER-QTY
                ELSE
                        SUBTRACT WS-INV-QTY(INV-INDEX) FROM 30 GIVING ORDER-QTY
                END-IF
                   DISPLAY ORDER-QTY
                   DISPLAY ''

		MOVE WS-INV-ITEM-NO(INV-INDEX) TO ORDER-ITEM-NO
		ADD ORDER-QTY TO WS-INV-QTY(INV-INDEX) GIVING WS-INV-QTY(INV-INDEX)
		WRITE INV-ORDER-RECORD
	END-IF.

 
080-LOG-TRANS.
        MOVE SPACE TO TRANS-OUTPUT-RECORD.
        MOVE WS-CUST-NAME(CUST-INDEX) TO TP-CUST-NAME.
           MOVE WS-CUST-STREET(CUST-INDEX) TO TP-CUST-STREET.
           MOVE WS-CUST-CITY(CUST-INDEX) TO TP-CUST-CITY.
           MOVE WS-CUST-REGION(CUST-INDEX) TO TP-CUST-REGION.
           MOVE WS-INV-ITEM-NAME(INV-INDEX) TO TP-INV-ITEM-NAME.
           MOVE WS-INV-QTY(INV-INDEX) TO TP-INV-QTY.
           MOVE WS-CUST-PAST-DUE(CUST-INDEX) TO TP-CUST-BALANCE.
           WRITE TRANS-OUTPUT-RECORD.


          


