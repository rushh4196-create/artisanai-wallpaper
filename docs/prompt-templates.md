# ARTISANAI — Prompt Templates (Daily Pipeline)

Style lock for **every** drop, both orientations: **cinematic teal-and-gold nature,
cloudyx_art style** — deep teal-blue + warm gold, moody, one small grounded subject,
huge sky/environment (70–80% of the frame), one consistent warm light, correct
anatomy and physics. Photorealistic HDR, hyperdetailed — **never** label outputs
"32K" in the app or store listing (see plan p.2: deliver 8K masters as 4K / phone-size).

## Shared style block (append to every prompt)
```
cinematic, hyperdetailed, photorealistic HDR, deep teal-blue and warm gold palette,
one small grounded subject, vast sky, single warm light source, soft atmospheric haze,
sharp foreground texture, natural depth of field, 8K master quality
```

## Negative prompt (every generation)
```
blurry, low-res, distorted anatomy, extra limbs, deformed hands, watermark, text,
logo, signature, cartoon, flat illustration, oversaturated, noisy, duplicate subject,
cropped subject, copyrighted character, celebrity likeness
```

## Landscape template (16:9 — Windows desktop)
```
[SUBJECT], [SETTING], wide cinematic landscape composition, subject small in frame
against a vast [SKY / ENVIRONMENT], deep teal-blue shadows, warm golden-hour light
from [DIRECTION], [WEATHER / ATMOSPHERE], [TEXTURE DETAIL, e.g. wet rock, pine needles,
flowing water], <SHARED STYLE BLOCK>
Aspect 16:9. Generate 4 candidates, keep the best-scoring one.
```

Example (Monday / Nature):
```
A lone hiker on a mountain ridge above a golden valley at dawn, wide cinematic
landscape composition, subject small against a vast teal sky with drifting mist,
deep teal-blue shadows, warm golden-hour light from the left, flowing waterfall
in the gorge below, sharp rock and pine texture, <SHARED STYLE BLOCK>
```

## Portrait template (9:16 — Android phone; composed, NOT a crop)
```
[SUBJECT], [SETTING], tall vertical composition, subject in the lower third,
towering [SKY / ENVIRONMENT] filling the upper two-thirds, deep teal-blue shadows,
warm golden-hour light from [DIRECTION], [WEATHER / ATMOSPHERE],
[TEXTURE DETAIL], <SHARED STYLE BLOCK>
Aspect 9:16. Generate 4 candidates, keep the best-scoring one.
```

Example (Monday / Nature, same theme as landscape):
```
A lone hiker on a mountain ridge, tall vertical composition, hiker in the lower
third, towering teal sky with drifting mist and a golden sun filling the upper
two-thirds, deep teal-blue shadows, warm golden-hour light from the left,
waterfall mist rising in the gorge, sharp rock texture, <SHARED STYLE BLOCK>
```

## Live-wallpaper note
- Live version is built **from the same day's master** — never a different image.
- Motion type comes from the calendar (e.g. Monday: drifting mist / flowing water).
- Methods, cheapest first: layered parallax → shader effects → short video loop.
- Limits: <10 MB Android, <25 MB Windows, 30 fps cap, seamless loop, static fallback included.

## Pipeline QC (before publish)
Resolution, blur, broken anatomy / text artefacts, duplicates vs past drops,
safety filter. Reject and regenerate on failure; never publish a broken drop.
