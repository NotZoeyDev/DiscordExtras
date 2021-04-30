#ifndef	_discordExtras_helper_server_
#define	_discordExtras_helper_server_

/* Module discordExtras_helper */

#include <string.h>
#include <mach/ndr.h>
#include <mach/boolean.h>
#include <mach/kern_return.h>
#include <mach/notify.h>
#include <mach/mach_types.h>
#include <mach/message.h>
#include <mach/mig_errors.h>
#include <mach/port.h>
	
/* BEGIN VOUCHER CODE */

#ifndef KERNEL
#if defined(__has_include)
#if __has_include(<mach/mig_voucher_support.h>)
#ifndef USING_VOUCHERS
#define USING_VOUCHERS
#endif
#ifndef __VOUCHER_FORWARD_TYPE_DECLS__
#define __VOUCHER_FORWARD_TYPE_DECLS__
#ifdef __cplusplus
extern "C" {
#endif
	extern boolean_t voucher_mach_msg_set(mach_msg_header_t *msg) __attribute__((weak_import));
#ifdef __cplusplus
}
#endif
#endif // __VOUCHER_FORWARD_TYPE_DECLS__
#endif // __has_include(<mach/mach_voucher_types.h>)
#endif // __has_include
#endif // !KERNEL
	
/* END VOUCHER CODE */

	
/* BEGIN MIG_STRNCPY_ZEROFILL CODE */

#if defined(__has_include)
#if __has_include(<mach/mig_strncpy_zerofill_support.h>)
#ifndef USING_MIG_STRNCPY_ZEROFILL
#define USING_MIG_STRNCPY_ZEROFILL
#endif
#ifndef __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__
#define __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__
#ifdef __cplusplus
extern "C" {
#endif
	extern int mig_strncpy_zerofill(char *dest, const char *src, int len) __attribute__((weak_import));
#ifdef __cplusplus
}
#endif
#endif /* __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__ */
#endif /* __has_include(<mach/mig_strncpy_zerofill_support.h>) */
#endif /* __has_include */
	
/* END MIG_STRNCPY_ZEROFILL CODE */


#ifdef AUTOTEST
#ifndef FUNCTION_PTR_T
#define FUNCTION_PTR_T
typedef void (*function_ptr_t)(mach_port_t, char *, mach_msg_type_number_t);
typedef struct {
        char            *name;
        function_ptr_t  function;
} function_table_entry;
typedef function_table_entry   *function_table_t;
#endif /* FUNCTION_PTR_T */
#endif /* AUTOTEST */

#ifndef	discordExtras_helper_MSG_COUNT
#define	discordExtras_helper_MSG_COUNT	1
#endif	/* discordExtras_helper_MSG_COUNT */

#include <mach/std_types.h>
#include <mach/mig.h>
#include <mach/mig.h>
#include <mach/mach_types.h>
#include "pathname_type.h"

#ifdef __BeforeMigServerHeader
__BeforeMigServerHeader
#endif /* __BeforeMigServerHeader */

#ifndef MIG_SERVER_ROUTINE
#define MIG_SERVER_ROUTINE
#endif


/* Routine discordExtras_patch */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
MIG_SERVER_ROUTINE
kern_return_t dex_discordExtras_patch
(
	mach_port_t server_port,
	pathname_t bundlePath,
	mach_msg_type_number_t bundlePathCnt,
	pathname_t patchedPath,
	mach_msg_type_number_t patchedPathCnt,
	pathname_t patchesPath,
	mach_msg_type_number_t patchesPathCnt
);

#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
boolean_t discordExtras_helper_server(
		mach_msg_header_t *InHeadP,
		mach_msg_header_t *OutHeadP);

#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
mig_routine_t discordExtras_helper_server_routine(
		mach_msg_header_t *InHeadP);


/* Description of this subsystem, for use in direct RPC */
extern const struct dex_discordExtras_helper_subsystem {
	mig_server_routine_t	server;	/* Server routine */
	mach_msg_id_t	start;	/* Min routine number */
	mach_msg_id_t	end;	/* Max routine number + 1 */
	unsigned int	maxsize;	/* Max msg size */
	vm_address_t	reserved;	/* Reserved */
	struct routine_descriptor	/*Array of routine descriptors */
		routine[1];
} dex_discordExtras_helper_subsystem;

/* typedefs for all requests */

#ifndef __Request__discordExtras_helper_subsystem__defined
#define __Request__discordExtras_helper_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		mach_msg_type_number_t bundlePathCnt;
		uint8_t bundlePath[2048];
		mach_msg_type_number_t patchedPathCnt;
		uint8_t patchedPath[2048];
		mach_msg_type_number_t patchesPathCnt;
		uint8_t patchesPath[2048];
	} __Request__discordExtras_patch_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Request__discordExtras_helper_subsystem__defined */


/* union of all requests */

#ifndef __RequestUnion__dex_discordExtras_helper_subsystem__defined
#define __RequestUnion__dex_discordExtras_helper_subsystem__defined
union __RequestUnion__dex_discordExtras_helper_subsystem {
	__Request__discordExtras_patch_t Request_discordExtras_patch;
};
#endif /* __RequestUnion__dex_discordExtras_helper_subsystem__defined */
/* typedefs for all replies */

#ifndef __Reply__discordExtras_helper_subsystem__defined
#define __Reply__discordExtras_helper_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		kern_return_t RetCode;
	} __Reply__discordExtras_patch_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Reply__discordExtras_helper_subsystem__defined */


/* union of all replies */

#ifndef __ReplyUnion__dex_discordExtras_helper_subsystem__defined
#define __ReplyUnion__dex_discordExtras_helper_subsystem__defined
union __ReplyUnion__dex_discordExtras_helper_subsystem {
	__Reply__discordExtras_patch_t Reply_discordExtras_patch;
};
#endif /* __ReplyUnion__dex_discordExtras_helper_subsystem__defined */

#ifndef subsystem_to_name_map_discordExtras_helper
#define subsystem_to_name_map_discordExtras_helper \
    { "discordExtras_patch", 500 }
#endif

#ifdef __AfterMigServerHeader
__AfterMigServerHeader
#endif /* __AfterMigServerHeader */

#endif	 /* _discordExtras_helper_server_ */
