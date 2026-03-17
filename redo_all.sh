#!/usr/bin/env bash
# Refait tous les extraits en prenant la totalité du clip source
set -euo pipefail

OUTDIR="/root/clawd/movie-clips/clips"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[..] $1${NC}"; }
err() { echo -e "${RED}[ERR]${NC} $1"; }

# $1=dossier $2=nom $3=url $4=description
dl_both() {
  local folder="$1"
  local name="$2"
  local url="$3"
  local desc="$4"
  local mp3="$OUTDIR/$folder/${name}.mp3"
  local mp4="$OUTDIR/$folder/${name}.mp4"
  local tmp="/tmp/dl_${name}"

  warn "↓ $desc"

  # --- Téléchargement best video+audio ---
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best" \
    --merge-output-format mp4 \
    --no-playlist \
    -o "${tmp}.%(ext)s" \
    "$url" --quiet 2>/dev/null || {
    yt-dlp -f "best" --no-playlist -o "${tmp}.%(ext)s" "$url" --quiet 2>/dev/null || {
      err "ÉCHEC download: $desc"
      return
    }
  }

  local raw
  raw=$(ls "${tmp}".* 2>/dev/null | head -1)
  if [ -z "$raw" ]; then
    err "Fichier introuvable: $desc"
    return
  fi

  # --- MP4 : réencode propre ---
  ffmpeg -y -i "$raw" \
    -c:v libx264 -preset fast -crf 22 \
    -c:a aac -b:a 192k \
    -movflags +faststart \
    "$mp4" -loglevel quiet 2>/dev/null && \
    log "MP4 ✓ $desc ($(du -h "$mp4" | cut -f1))" || err "MP4 ÉCHEC: $desc"

  # --- MP3 : extraction audio propre, normalisation volume ---
  ffmpeg -y -i "$raw" \
    -vn \
    -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
    -acodec libmp3lame -q:a 2 \
    "$mp3" -loglevel quiet 2>/dev/null && \
    log "MP3 ✓ $desc ($(du -h "$mp3" | cut -f1))" || err "MP3 ÉCHEC: $desc"

  rm -f "$raw"
}

echo ""
echo "🎬 Refonte complète — audio + vidéo full clip"
echo "=============================================="

echo ""
echo "🇧🇪 DIKKENEK"
dl_both "dikkenek" "comment_il_est_a_laise"  "https://www.youtube.com/watch?v=tWjdz8A1KLU" "Dikkenek - Comment il est à l'aise (1:27)"
dl_both "dikkenek" "fricadelle"               "https://www.youtube.com/watch?v=N7KrCafIz1A" "Dikkenek - La fricadèlle (3:46)"
dl_both "dikkenek" "tu_ne_me_vois_pas"        "https://www.youtube.com/watch?v=QVEZG9PnEqo" "Dikkenek - Tu ne me vois pas (1:37)"
dl_both "dikkenek" "carjacking"               "https://www.youtube.com/watch?v=-FJfc2qtvJU" "Dikkenek - Carjacking (1:44)"
dl_both "dikkenek" "tendu_natasha"            "https://www.youtube.com/watch?v=l_J4NYm5-Po" "Dikkenek - T'es tendu Natasha (0:45)"

echo ""
echo "🎭 BERNIE"
dl_both "bernie" "assaut_a_la_pelle"          "https://www.youtube.com/watch?v=61lwMjuZm5o" "Bernie - L'assaut à la pelle (3:44)"
dl_both "bernie" "vous_vous_promenez"         "https://www.youtube.com/watch?v=liIjlXguUFY" "Bernie - Vous vous promenez? (1:14)"
dl_both "bernie" "scene_magasin"              "https://www.youtube.com/watch?v=YBkNdptTiqQ" "Bernie - Scène du magasin (0:37)"
dl_both "bernie" "noel"                       "https://www.youtube.com/watch?v=4OBQq8gqwDU" "Bernie - Noël (4:22)"

echo ""
echo "🪖 LA 7ÈME COMPAGNIE"
dl_both "7eme-compagnie" "allo_eglantine_ici_mirabelle" "https://www.youtube.com/watch?v=bEdU0wS0bqo" "7e Cie - Allô Eglantine ici Mirabelle (0:38)"
dl_both "7eme-compagnie" "trop_charge"         "https://www.youtube.com/watch?v=C9FguLg1_UA" "7e Cie - Il est trop chargé (2:52)"
dl_both "7eme-compagnie" "falzar"              "https://www.youtube.com/watch?v=1KdptN97WZU" "7e Cie - Donne ton falzar (2:24)"
dl_both "7eme-compagnie" "chateau_vieux"       "https://www.youtube.com/watch?v=Jlv00M_MXVc" "7e Cie - Château vieux (4:30)"

echo ""
echo "🐧 LA CITÉ DE LA PEUR"
dl_both "cite-de-la-peur" "simon_jeremy"       "https://www.youtube.com/watch?v=21-4kI9hv50" "Cité de la Peur - Simon Jérémy (3:36)"
dl_both "cite-de-la-peur" "tu_bluffes_martoni" "https://www.youtube.com/watch?v=tNeig1leks8" "Cité de la Peur - Tu bluffes Martoni (2:24)"
dl_both "cite-de-la-peur" "bout_de_pomme_de_terre" "https://www.youtube.com/watch?v=VNtQmMveA7I" "Cité de la Peur - Bout de pomme de terre (0:13)"
dl_both "cite-de-la-peur" "hippo_ou_elephant"  "https://www.youtube.com/watch?v=Mzz6-A7U3JU" "Cité de la Peur - Hippo ou éléphant (0:26)"
dl_both "cite-de-la-peur" "quand_je_suis_content_je_vomis" "https://www.youtube.com/watch?v=NSx2tSfh3p4" "Cité de la Peur - Quand je suis content je vomis (2:35)"
dl_both "cite-de-la-peur" "aeroport_nice"      "https://www.youtube.com/watch?v=wEW1S1P_Umk" "Cité de la Peur - Aéroport de Nice (2:56)"

echo ""
echo "📷 C'EST ARRIVÉ PRÈS DE CHEZ VOUS"
dl_both "cest-arrive" "petit_gregory"          "https://www.youtube.com/watch?v=TtyEhDgXNX4" "CAPCDV - Petit Gregory (1:30)"
dl_both "cest-arrive" "comment_lester_un_corps" "https://www.youtube.com/watch?v=gGBaK3aSgkQ" "CAPCDV - Comment lester un corps (1:14)"
dl_both "cest-arrive" "mauvaise_peau"          "https://www.youtube.com/watch?v=BkFqi1M3ciI" "CAPCDV - Mauvaise peau (0:49)"
dl_both "cest-arrive" "anniversaire"           "https://www.youtube.com/watch?v=k0JUfaB0MTo" "CAPCDV - L'anniversaire (3:35)"
dl_both "cest-arrive" "veilleur_de_nuit"       "https://www.youtube.com/watch?v=HtH_Hosomok" "CAPCDV - Veilleur de nuit (2:08)"

echo ""
echo "=============================================="
echo "🎉 Bilan final:"
echo ""
echo "MP3: $(find "$OUTDIR" -name '*.mp3' | wc -l)/25"
echo "MP4: $(find "$OUTDIR" -name '*.mp4' | wc -l)/25"
echo ""
echo "Taille totale: $(du -sh "$OUTDIR" | cut -f1)"
find "$OUTDIR" -name "*.mp3" | sort | while read f; do
  dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null | xargs printf "%.0f" 2>/dev/null || echo "?")
  echo "  🎵 $(basename $(dirname $f))/$(basename $f) — ${dur}s"
done

openclaw system event --text "Done: movie-clips refaits proprement, full durée, audio normalisé. Prêt pour git push." --mode now 2>/dev/null || true
