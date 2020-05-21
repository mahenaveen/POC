PROMPT *-*-*-*-*-*-*-*-  DIRECTORY CREATION STARTS.... *-*-*-*-*-*-*-*-

CREATE OR REPLACE DIRECTORY AUG_DIR
AS '@"&&path\Mahi\SVN\13_rep_utl_col\Files"';

PROMPT *-*-*-*-*-*-*-*-  DIRECTORY CREATION ENDS.... *-*-*-*-*-*-*-*-

PROMPT *-*-*-*-*-*-*-*-  GRANTING PERMISSION TO HR SCHEMA STARTS.... *-*-*-*-*-*-*-*-

GRANT all ON DIRECTORY AUG_DIR TO PUBLIC;

GRANT EXECUTE ON utl_file TO PUBLIC;

PROMPT *-*-*-*-*-*-*-*-  GRANTING PERMISSION TO HR SCHEMA STARTS.... *-*-*-*-*-*-*-*-
