#include <pthread.h>
#define G_LOG_LEVEL_ERROR (1 << 2)
#define G_LOG_DOMAIN ((char*) 0)
#define G_UNLIKELY(expr) (__builtin_expect ((expr) != 0, 0))
#define g_error(...)    do { g_log (G_LOG_DOMAIN, G_LOG_LEVEL_ERROR, __VA_ARGS__); for (;;); } while (0)

void   g_list_free          (void         *list);
typedef void     (*GFunc)          (void* data, void* user_data);
void   g_list_foreach       (void         *list,
			     GFunc          func,
			     void*       user_data);
void *g_list_copy          (void         *list);
static pthread_mutex_t assemblies_mutex;
static void *loaded_assemblies = NULL;
const char *g_strerror       (int errnum);
void           g_log                  (const char *log_domain, int log_level, const char *format, ...);
static inline void
mono_os_mutex_lock (pthread_mutex_t *mutex)
{
	int res;

	res = pthread_mutex_lock (mutex);
	if (G_UNLIKELY (res != 0))
		g_error ("%s: pthread_mutex_lock failed with \"%s\" (%d)", __func__, g_strerror (res), res);
}

static inline void
mono_os_mutex_unlock (pthread_mutex_t *mutex)
{
	int res;

	res = pthread_mutex_unlock (mutex);
	if (G_UNLIKELY (res != 0))
		g_error ("%s: pthread_mutex_unlock failed with \"%s\" (%d)", __func__, g_strerror (res), res);
}

void
mono_assembly_foreach (GFunc func, void* user_data)
{
	void *copy;

	/*
	 * We make a copy of the list to avoid calling the callback inside the 
	 * lock, which could lead to deadlocks.
	 */
	mono_os_mutex_lock (&assemblies_mutex);
	copy = g_list_copy (loaded_assemblies);
	mono_os_mutex_unlock (&assemblies_mutex);

	g_list_foreach (loaded_assemblies, func, user_data);

	g_list_free (copy);
}