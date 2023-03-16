/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "#191919",     /* after initialization */
	[INPUT] =  "#282a2e",   /* during input */
	[FAILED] = "#cc6666",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
