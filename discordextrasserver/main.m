#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <pthread/spawn.h>
#import "../Utils.h"
extern char **environ;

#import "discordExtras_daemonServer.h"

#define MEMORYSTATUS_CMD_SET_JETSAM_TASK_LIMIT 6

typedef boolean_t (*dispatch_mig_callback_t)(mach_msg_header_t *message, mach_msg_header_t *reply);
mach_msg_return_t dispatch_mig_server(dispatch_source_t ds, size_t maxmsgsz, dispatch_mig_callback_t callback);
kern_return_t bootstrap_check_in(mach_port_t bootstrap_port, const char *service, mach_port_t *server_port);
int memorystatus_control(uint32_t command, int32_t pid, uint32_t flags, void *buffer, size_t buffersize);

kern_return_t dex_discordExtras_patch(mach_port_t server_port, pathname_t bundlePathC, mach_msg_type_number_t bundlePathCnt, pathname_t patchedPathC, mach_msg_type_number_t patchedPathCnt, pathname_t patchesPathC, mach_msg_type_number_t patchesPathCnt) {
	NSString *bundlePath = [[NSString alloc] initWithBytes:bundlePathC length:bundlePathCnt encoding:NSUTF8StringEncoding];
	NSString *patchedPath = [[NSString alloc] initWithBytes:patchedPathC length:patchedPathCnt encoding:NSUTF8StringEncoding];
	NSString *patchesPath = [[NSString alloc] initWithBytes:patchesPathC length:patchesPathCnt encoding:NSUTF8StringEncoding];

	pid_t pid;
	char *argv[] = {
		(char *)[@"/usr/bin/jsbundletools" UTF8String],
		(char *)[@"-m" UTF8String],
		(char *)[@"patch" UTF8String],
		(char *)[@"-p" UTF8String],
		(char *)[bundlePath UTF8String],
		(char *)[@"-d" UTF8String],
		(char *)[patchesPath UTF8String],
		(char *)[@"-n" UTF8String],
		(char *)[patchedPath UTF8String],
		NULL
	};

	posix_spawnattr_t attr;
	int status;
	posix_spawnattr_init(&attr);
	posix_spawnattr_set_qos_class_np(&attr, QOS_CLASS_USER_INTERACTIVE);
	posix_spawn(&pid, argv[0], NULL, &attr, argv, environ);
	waitpid(pid, &status, 0);
	posix_spawnattr_destroy(&attr);

	return (status == 0) ? KERN_SUCCESS : KERN_FAILURE;
}

int main() {
  memorystatus_control(MEMORYSTATUS_CMD_SET_JETSAM_TASK_LIMIT, getpid(), 0, NULL, 0);

	mach_port_t server_port;
	kern_return_t err;
	if ((err = bootstrap_check_in(bootstrap_port, getServiceName(), &server_port))){
		NSLog(@"[DES] Failed to check in: %s", mach_error_string(err));
		return -1;
	}

	NSLog(@"[DES] Server is started!");

	dispatch_source_t server = dispatch_source_create(DISPATCH_SOURCE_TYPE_MACH_RECV, server_port, 0, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0));
	dispatch_source_set_event_handler(server, ^{
		dispatch_mig_server(server, MAX(sizeof(union __RequestUnion__dex_discordExtras_helper_subsystem), sizeof(union __ReplyUnion__dex_discordExtras_helper_subsystem)), discordExtras_helper_server	);
	});
	dispatch_resume(server);
	dispatch_main();

	return 0;
}
