-- DAY_DCHART_VIEW
CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."DAY_DCHART_VIEW" ("BE_FLOOR", "LABEL", "BE_AC_ENERGY", "BE_PLUG_ENERGY", "BE_LIGHT_ENERGY") AS 
  SELECT 
 be_floor,
 TO_CHAR(TRUNC(be_date, 'HH24'), 'HH24:MI') AS label,
           SUM(be_ac_energy) AS be_ac_energy,
           SUM(be_plug_energy) AS be_plug_energy,
           SUM(be_light_energy) AS be_light_energy
    FROM be_device
    WHERE TO_CHAR(be_date, 'YY-MM-DD') = TO_CHAR(SYSDATE, 'YY-MM-DD')
      AND b_id = 'gta'
    GROUP BY  be_floor, TRUNC(be_date, 'HH24')
    ORDER BY label;