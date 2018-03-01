/* Generated by            cobc 1.1.0 */
/* Generated from          inventory.cbl */
/* Generated at            Feb 28 2018 03:43:58 EST */
/* OpenCOBOL build date    Feb 07 2016 10:28:13 */
/* OpenCOBOL package date  Feb 06 2009 10:30:55 CET */
/* Compile command         cobc -free -x -g -debug -ftraceall -o exe inventory.cbl */

/* Frame stack declaration */
struct cob_frame {
	int	perform_through;
	void	*return_address;
};

/* Union for CALL statement */
union cob_call_union {
	void *(*funcptr)();
	int  (*funcint)();
	void *func_void;
};
union cob_call_union	cob_unifunc;


/* Storage */

/* PROGRAM-ID : NKU CSC407 OLDIE ASSIGNMENT */
static unsigned char b_1[4] __attribute__((aligned));	/* RETURN-CODE */
static unsigned char b_14[55] __attribute__((aligned));	/* INV-FILE_record */
static unsigned char b_23[87] __attribute__((aligned));	/* CUST-FILE_record */
static unsigned char b_32[29] __attribute__((aligned));	/* TRANS-FILE_record */
static unsigned char b_41[52] __attribute__((aligned));	/* ERROR-FILE_record */
static unsigned char b_57[142] __attribute__((aligned));	/* TRANS-OUTPUT-FILE_record */
static unsigned char b_62[14] __attribute__((aligned));	/* INV-ORDER-FILE_record */
static unsigned char b_63[5] __attribute__((aligned));	/* SWITCHES */
static unsigned char b_69[936] __attribute__((aligned));	/* WS-INV-TABLE */
static unsigned char b_71[4] __attribute__((aligned));	/* INV-INDEX */
static unsigned char b_77[810] __attribute__((aligned));	/* WS-CUST-TABLE */
static unsigned char b_79[4] __attribute__((aligned));	/* CUST-INDEX */
static unsigned char b_86[10] __attribute__((aligned));	/* WORK-FIELDS */

/* End of storage */


/* Attributes */

static const cob_field_attr a_1 = {33, 0, 0, 0, NULL};
static const cob_field_attr a_2 = {16, 5, 0, 1, NULL};
static const cob_field_attr a_3 = {16, 1, 0, 0, NULL};
static const cob_field_attr a_4 = {16, 2, 0, 0, NULL};
static const cob_field_attr a_5 = {36, 4, 2, 0, "9\002\000\000\000.\001\000\000\0009\002\000\000\000"};
static const cob_field_attr a_6 = {16, 4, 2, 1, NULL};
static const cob_field_attr a_7 = {16, 5, 0, 0, NULL};
static const cob_field_attr a_8 = {36, 5, 2, 0, "9\003\000\000\000.\001\000\000\0009\002\000\000\000"};
static const cob_field_attr a_9 = {16, 5, 2, 1, NULL};
static const cob_field_attr a_10 = {16, 6, 0, 0, NULL};
static const cob_field_attr a_11 = {1, 0, 0, 0, NULL};
static const cob_field_attr a_12 = {16, 6, 2, 0, NULL};
static const cob_field_attr a_13 = {16, 2, 1, 0, NULL};
static const cob_field_attr a_14 = {16, 3, 2, 0, NULL};

/* Fields */

/* PROGRAM-ID : NKU CSC407 OLDIE ASSIGNMENT */
static cob_field f_6	= {6, b_14, &a_1};	/* INV-ITEM-NO */
static cob_field f_8	= {25, b_14 + 11, &a_1};	/* INV-ITEM-NAME */
static cob_field f_9	= {2, b_14 + 36, &a_4};	/* INV-QTY */
static cob_field f_11	= {2, b_14 + 43, &a_4};	/* INV-REORDER-PT */
static cob_field f_13	= {5, b_14 + 50, &a_5};	/* INV-PRICE */
static cob_field f_14	= {55, b_14, &a_1};	/* INV-FILE_record */
static cob_field f_16	= {5, b_23, &a_1};	/* CUST-NO */
static cob_field f_18	= {23, b_23 + 10, &a_1};	/* CUST-NAME */
static cob_field f_19	= {23, b_23 + 33, &a_1};	/* CUST-STREET */
static cob_field f_20	= {13, b_23 + 56, &a_1};	/* CUST-CITY */
static cob_field f_21	= {12, b_23 + 69, &a_1};	/* CUST-REGION */
static cob_field f_22	= {6, b_23 + 81, &a_8};	/* CUST-PAST-DUE */
static cob_field f_23	= {87, b_23, &a_1};	/* CUST-FILE_record */
static cob_field f_25	= {5, b_32, &a_1};	/* TRANS-CUST-NO */
static cob_field f_27	= {6, b_32 + 10, &a_10};	/* TRANS-ITEM-NO */
static cob_field f_29	= {1, b_32 + 22, &a_3};	/* TRANS-QTY-ORD */
static cob_field f_32	= {29, b_32, &a_1};	/* TRANS-FILE_record */
static cob_field f_33	= {52, b_41, &a_11};	/* ERROR-RECORD */
static cob_field f_34	= {5, b_41, &a_7};	/* ERROR-CUST-NO */
static cob_field f_41	= {52, b_41, &a_1};	/* ERROR-FILE_record */
static cob_field f_42	= {142, b_57, &a_11};	/* TRANS-OUTPUT-RECORD */
static cob_field f_43	= {23, b_57, &a_1};	/* TP-CUST-NAME */
static cob_field f_44	= {23, b_57 + 23, &a_1};	/* TP-CUST-STREET */
static cob_field f_45	= {13, b_57 + 46, &a_1};	/* TP-CUST-CITY */
static cob_field f_46	= {12, b_57 + 59, &a_1};	/* TP-CUST-REGION */
static cob_field f_47	= {25, b_57 + 71, &a_1};	/* TP-INV-ITEM-NAME */
static cob_field f_48	= {2, b_57 + 96, &a_4};	/* TP-INV-QTY */
static cob_field f_50	= {6, b_57 + 103, &a_12};	/* TP-GROSS-COST */
static cob_field f_52	= {6, b_57 + 114, &a_12};	/* TP-DISCOUNT */
static cob_field f_54	= {6, b_57 + 125, &a_12};	/* TP-NETCOST */
static cob_field f_56	= {6, b_57 + 136, &a_12};	/* TP-CUST-BALANCE */
static cob_field f_57	= {142, b_57, &a_1};	/* TRANS-OUTPUT-FILE_record */
static cob_field f_58	= {14, b_62, &a_11};	/* INV-ORDER-RECORD */
static cob_field f_59	= {6, b_62, &a_1};	/* ORDER-ITEM-NO */
static cob_field f_61	= {2, b_62 + 12, &a_4};	/* ORDER-QTY */
static cob_field f_62	= {14, b_62, &a_1};	/* INV-ORDER-FILE_record */
static cob_field f_87	= {5, b_86, &a_2};	/* INV-NUM-IN */
static cob_field f_88	= {5, b_86 + 5, &a_2};	/* CUST-NUM-IN */

/* End of fields */

/* Constants */
static cob_field c_1	= {24, (unsigned char *)"data_files/inventory.dat", &a_1};
static cob_field c_2	= {24, (unsigned char *)"data_files/customers.dat", &a_1};
static cob_field c_3	= {27, (unsigned char *)"data_files/transactions.dat", &a_1};
static cob_field c_4	= {21, (unsigned char *)"data_files/errors.dat", &a_1};
static cob_field c_5	= {37, (unsigned char *)"data_files/transactions_processed.dat", &a_1};
static cob_field c_6	= {30, (unsigned char *)"data_files/inventory_order.dat", &a_1};
static cob_field c_7	= {1, (unsigned char *)"1", &a_3};
static cob_field c_8	= {2, (unsigned char *)"01", &a_13};
static cob_field c_9	= {2, (unsigned char *)"02", &a_13};
static cob_field c_10	= {3, (unsigned char *)"025", &a_14};
static cob_field c_11	= {2, (unsigned char *)"05", &a_13};
static cob_field c_12	= {1, (unsigned char *)"0", &a_3};
static cob_field c_13	= {14, (unsigned char *)"NEED TO REODER", &a_1};
static cob_field c_14	= {1, (unsigned char *)" ", &a_1};

