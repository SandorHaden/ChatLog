# Beszélgetés-konvenció (Air Stripper Modeller)

> Ez a dokumentum leírja, hogyan tárolódnak a Sanyival folytatott
> Boborján-beszélgetések ehhez a projekthez. A szabály a 2026-06-11-i
> munkamenetben született, és a `MEMORY.md` / `AGENTS.md` is hivatkozik rá.

## Hely

```
{projekt-mappa}/docs/conversations/
├── index.md                       # tartalomjegyzék (mindig naprakész)
├── meta/
│   └── CONVERSATION-CONVENTION.md # ez a fájl
└── from-ÉÉÉÉ-HH-NN-HHhMMm-to-ÉÉÉÉ-HH-NN-HHhMMm-{téma-slug}.md
```

A mappa **nem rejtett** (nincs pont prefix, nincs `_` prefix).

## Fájlnév-formátum

```
from-{kezdés-ÉÉÉÉ-HH-NN-HHhMMm}-to-{befejezés-ÉÉÉÉ-HH-NN-HHhMMm}-{téma-slug}.md
```

- **`from` a kezdő időpont ELÉ kerül**, NEM mögé.
- **`to` a befejezés időpont ELÉ kerül**, NEM mögé.
- A teljes minta tehát: `from-START-to-END-tema.md` (egyetlen kötőjeles lánc).
- **Óra és perc két számjegyű, nullával feltöltve** (pl. `08h15m`, nem `8h15m`).
- **A téma-slug max. 5 szó, kötőjellel elválasztva, ASCII-only (ékezet nélkül).**
- **Időzóna NINCS a fájlnévben** — csak a metaadat-fejlécben.
- Mindig **helyi idő** (Europe/Budapest, alapértelmezetten CET, nyáron CEST).

Példa:

```
from-2026-06-10-04h23m-to-2026-06-10-18h24m-air-stripper-9-fazis.md
from-2026-06-11-08h15m-to-2026-06-11-10h28m-munkamenet-konvencio.md
from-2026-06-12-02h00m-to-2026-06-12-02h45m-ejszakai-kerdes.md
```

## Darabolás

- **Ideális méret:** 20-30 KB.
- **Maximum:** 50 KB.
- Ha nagyobb, `_r1`, `_r2`, ... toldalék a fájlnév végén:

```
from-2026-06-10-04h23m-to-2026-06-10-18h24m-air-stripper-9-fazis_r1.md
from-2026-06-10-04h23m-to-2026-06-10-18h24m-air-stripper-9-fazis_r2.md
```

A szegmensek **időrendben** követik egymást; a téma-határoknál (ahol új téma
indul) lehet vágni.

## Fájl belső struktúrája

```markdown
# Munkamenet: {rövid téma}

## Metaadat
- **Kezdés:** {YYYY-MM-DD HH:MM} ({CET|CEST})
- **Befejezés:** {YYYY-MM-DD HH:MM}
- **Időtartam:** {Xh Ym}
- **Futtatott modellek:** {lista}
- **Projekt:** {projektnév}
- **Érintett fájlok:** {lista}
- **Státusz:** {folyamatban | kész | megszakítva}

## Tartalom
[Szó szerinti üzenetváltások, Qwen promptok, kódrészletek,
 döntések, tool-eredmények, időrendben]

## Összefoglaló
[A legfontosabb döntések, tanulságok, TODO-k]

## Kapcsolódó munkamenetek
- {előző munkamenet fájlneve}
- {következő munkamenet fájlneve}
```

## Mikor készül új fájl?

- Minden **új beszélgetés-munkamenet** elején (vagy végén) új fájl.
- Ha a téma gyökeresen megváltozik (más ügy, más projekt), új munkamenet
  indul, és az új fájlban folytatódik.
- Ha a fájl mérete átlépi az 50 KB-ot, szegmensekre bontjuk (`_r1`, `_r2`).

## Session-end handler (mentési szabály)

Amikor a munkamenet véget ér (bármely trigger alapján), Boborján:

1. Összegyűjti az aktuális munkamenet üzeneteit
2. Készít egy RÖVID összefoglalót (max. 5-10 sor)
3. Frissíti a `MEMORY.md` "Aktuális gondolatmenet" szekcióját
4. Frissíti a munkamenet-fájl végét ("## Összefoglaló" szekció)
5. Frissíti a `docs/conversations/index.md` táblázatát

Ezt a műveletet a következő 6 trigger bármelyike aktiválja:

| # | Trigger | Mikor ismerem fel? |
|---|---------|---------------------|
| 1 | **Explicit "VÉGE"** | Te mondod: "Munkamenet vége", "Session vége", "Bezárom", "Elmegyek aludni", "Holnap folytatjuk" |
| 2 | **Számítógép leáll / alvás** | A Control UI kapcsolata megszakad, a session `idle` státuszba kerül |
| 3 | **OpenClaw bezárás** | A Control UI bezáródik, a session inaktívvá válik |
| 4 | **Új munkamenet indítása** | Amikor te új beszélgetést kezdesz, a régi session "archív" státuszba kerül |
| 5 | **Szokatlan csend** | Ha 30+ perc nem jön üzenet tőled, Boborján rákérdez: "Még tart a munkamenet, vagy lezárjam?" |
| 6 | **Lefagyás / összeomlás** | A session megszakad, de a JSONL fájlok megmaradnak - innen tudom, hol tartottunk |

## Gondolatmenet folytatása (következő munkamenet indítása)

A munkamenet-végi mentés után a `MEMORY.md` mindig tartalmazza az
**"Aktuális gondolatmenet"** szekciót, ami a Control UI induláskor
automatikusan betöltődik.

A session-eleji Boborján-kérdés-sor **kiegészül** a következő kérdéssel:

> "3. kérdés: Szeretnéd-e, hogy betöltsem az előző munkamenet:
>  (1) rövid összefoglalóját a MEMORY.md-ből,
>  (2) az utolsó 20 üzenetét a munkamenet-fájlból,
>  (3) a teljes munkamenet-fájlt (minden üzenetet),
>  vagy (4) egyáltalán nem?"

Ez biztosítja, hogy a beszélgetések **folytonosak** maradjanak, és a
gondolatmenet ne szakadjon meg akkor sem, ha a munkamenet véget ér.

## `index.md` (tartalomjegyzék)

A mappa gyökerében lévő `index.md` táblázatos formában listázza az
összes munkamenet-fájlt, dátum + téma + méret + státusz oszlopokkal.
Boborján frissíti minden új munkamenet végén.

## Session-eleji Boborján-viselkedés (fontos!)

Amikor Boborján **új munkamenetet** kezd (vagy felismeri, hogy ez új
beszélgetés), **az első kérdés** az alábbi kell, hogy legyen:

1. **"Alkalmazzuk-e a beszélgetés-konvenciót erre a munkamenetre?"**
   - **Igen** → a konvenció szerint dolgozunk: fájlnév, mappa, mentés.
   - **Nem** → a munkamenet fájlmentés nélkül, szabadon folyik.

2. **Ha igen**, Boborján rákérdez az **aktuális projektre**:
   - **"Folytassuk az aktív projektet: `{Aktív projekt neve}`?"**
     (Az aktív projekt a `MEMORY.md`-ben van rögzítve.)
   - **Igen** → betölti a projekt `docs/conversations/` mappáját,
     felajánlja a **legutolsó munkamenet betöltését** referenciaként
     (képernyőre + modell-kontextusba).
   - **Nem** → Boborján felsorolja az összes ismert projektet
     (a workspace `source/repos/` mappa és a `MEMORY.md` korábbi
     aktív-projekt-listája alapján), és felajánlja, hogy:
       - Válasszunk a listából.
       - Vagy hozzunk létre új projektet.

3. **Ha új projektet választunk**, Boborján:
   - Létrehozza az új projekt `docs/conversations/` mappáját.
   - Frissíti a `MEMORY.md` "Aktív projekt" sorát.
   - Új munkamenet-fájlt nyit.

A session-eleji kérdés-sor **az első interakció** kell, hogy legyen, és
**csak egyszer** hangzik el sessionenként. Ha Sanyi bármikor jelzi, hogy
mégis konvenció nélkül akar dolgozni, Boborján átvált.

## Hogyan tölti vissza Sanyi?

| Szükséglet | Teendő |
|-----------|--------|
| **Ember által olvasni** | Megnyitja a fájlt VS Code-ban vagy jegyzettömbben |
| **Modell memóriájába tölteni** | Rákérdez: "Boborján, töltsd be a ...-to-... fájlt" |
| **Csak a legutolsó N üzenetet** | A Control UI-ban görget, vagy `sessions_history` |
| **A teljes eddigi munkát áttekinteni** | `index.md` megnyitása, onnan navigál |

## Biztonsági mentés

A `docs/conversations/` mappa a projekt Git repository része, így
minden commit/release tag-gel együtt mentődik a GitHubra.
Helyi backup havonta: kézzel `zip`-elve a `Documents/conversations-backup/`
mappába.

## Mikor frissül ez a dokumentum?

- Amikor a konvenció megváltozik → Boborján frissíti, Sanyi jóváhagyja.
- Minden release tag-gel együtt commitolandó.