#!/usr/bin/env bash
# Téléchargement extraits VIDÉO (MP4 ~10-15s)
set -euo pipefail

OUTDIR="/root/clawd/movie-clips/clips"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[..] $1${NC}"; }
err() { echo -e "${RED}[ERR]${NC} $1"; }

dl_video() {
  local folder="$1"
  local name="$2"
  local url="$3"
  local start="$4"
  local duration="$5"
  local desc="$6"
  local outfile="$OUTDIR/$folder/${name}.mp4"

  if [ -f "$outfile" ]; then
    log "Déjà présent: $name.mp4"
    return
  fi

  warn "Vidéo: $desc"

  local tmpfile="/tmp/vid_${name}_raw"
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best" \
    --merge-output-format mp4 \
    --no-playlist \
    -o "${tmpfile}.%(ext)s" \
    "$url" --quiet 2>/dev/null || {
      # fallback: best
      yt-dlp -f "best" --no-playlist -o "${tmpfile}.%(ext)s" "$url" --quiet 2>/dev/null || {
        err "Échec download vidéo: $desc"
        return
      }
    }

  local rawfile
  rawfile=$(ls "${tmpfile}".* 2>/dev/null | head -1)
  if [ -z "$rawfile" ]; then
    err "Fichier non trouvé: $desc"
    return
  fi

  ffmpeg -y -ss "$start" -t "$duration" \
    -i "$rawfile" \
    -c:v libx264 -preset fast -crf 23 \
    -c:a aac -b:a 128k \
    -movflags +faststart \
    "$outfile" -loglevel quiet 2>/dev/null || {
      err "Échec ffmpeg vidéo: $desc"
      rm -f "$rawfile"
      return
    }

  rm -f "$rawfile"
  log "✓ $desc → $(du -h "$outfile" | cut -f1)"
}

echo ""
echo "🎬 Téléchargement des extraits VIDÉO"
echo "======================================"

echo ""
echo "🇧🇪 DIKKENEK"
dl_video "dikkenek" "au_bar_comment_il_est_a_laise" "https://www.youtube.com/watch?v=tWjdz8A1KLU" "0:00" "14" "Dikkenek - Comment il est à l'aise"
dl_video "dikkenek" "fricadelle" "https://www.youtube.com/watch?v=N7KrCafIz1A" "0:00" "13" "Dikkenek - La fricadèlle"
dl_video "dikkenek" "tu_ne_me_vois_pas" "https://www.youtube.com/watch?v=QVEZG9PnEqo" "0:00" "13" "Dikkenek - Tu ne me vois pas"
dl_video "dikkenek" "carjacking" "https://www.youtube.com/watch?v=-FJfc2qtvJU" "0:00" "12" "Dikkenek - Carjacking"
dl_video "dikkenek" "tendu_natasha" "https://www.youtube.com/watch?v=l_J4NYm5-Po" "0:00" "13" "Dikkenek - T'es tendu Natasha"

echo ""
echo "🎭 BERNIE"
dl_video "bernie" "assaut_a_la_pelle" "https://www.youtube.com/watch?v=61lwMjuZm5o" "0:00" "13" "Bernie - L'assaut à la pelle"
dl_video "bernie" "vous_vous_promenez" "https://www.youtube.com/watch?v=liIjlXguUFY" "0:00" "14" "Bernie - Vous vous promenez?"
dl_video "bernie" "scene_magasin" "https://www.youtube.com/watch?v=YBkNdptTiqQ" "0:00" "13" "Bernie - Scène du magasin"
dl_video "bernie" "noel" "https://www.youtube.com/watch?v=4OBQq8gqwDU" "0:00" "12" "Bernie - Noël"

echo ""
echo "🪖 LA 7ÈME COMPAGNIE"
dl_video "7eme-compagnie" "allo_eglantine_ici_mirabelle" "https://www.youtube.com/watch?v=bEdU0wS0bqo" "0:00" "14" "7e Cie - Allô Eglantine ici Mirabelle"
dl_video "7eme-compagnie" "trop_charge" "https://www.youtube.com/watch?v=C9FguLg1_UA" "0:00" "13" "7e Cie - Il est trop chargé"
dl_video "7eme-compagnie" "falzar" "https://www.youtube.com/watch?v=1KdptN97WZU" "0:00" "12" "7e Cie - Donne ton falzar"
dl_video "7eme-compagnie" "repliques_cultes" "https://www.youtube.com/watch?v=2lZiDS_1AR0" "0:00" "15" "7e Cie - Compilation répliques"
dl_video "7eme-compagnie" "chateau_vieux" "https://www.youtube.com/watch?v=Jlv00M_MXVc" "0:00" "13" "7e Cie - Château vieux"

echo ""
echo "🐧 LA CITÉ DE LA PEUR"
dl_video "cite-de-la-peur" "simon_jeremy" "https://www.youtube.com/watch?v=21-4kI9hv50" "0:00" "14" "Cité de la Peur - Simon Jérémy"
dl_video "cite-de-la-peur" "tu_bluffes_martoni" "https://www.youtube.com/watch?v=tNeig1leks8" "0:00" "14" "Cité de la Peur - Tu bluffes Martoni"
dl_video "cite-de-la-peur" "bout_de_pomme_de_terre" "https://www.youtube.com/watch?v=VNtQmMveA7I" "0:00" "13" "Cité de la Peur - Bout de pomme de terre"
dl_video "cite-de-la-peur" "hippo_ou_elephant" "https://www.youtube.com/watch?v=Mzz6-A7U3JU" "0:00" "14" "Cité de la Peur - Hippo ou éléphant"
dl_video "cite-de-la-peur" "quand_je_suis_content_je_vomis" "https://www.youtube.com/watch?v=NSx2tSfh3p4" "0:00" "13" "Cité de la Peur - Quand je suis content je vomis"
dl_video "cite-de-la-peur" "aeroport_nice" "https://www.youtube.com/watch?v=wEW1S1P_Umk" "0:00" "14" "Cité de la Peur - Aéroport de Nice"

echo ""
echo "📷 C'EST ARRIVÉ PRÈS DE CHEZ VOUS"
dl_video "cest-arrive" "petit_gregory" "https://www.youtube.com/watch?v=TtyEhDgXNX4" "0:00" "13" "CAPCDV - Petit Gregory"
dl_video "cest-arrive" "comment_lester_un_corps" "https://www.youtube.com/watch?v=gGBaK3aSgkQ" "0:00" "14" "CAPCDV - Comment lester un corps"
dl_video "cest-arrive" "mauvaise_peau" "https://www.youtube.com/watch?v=BkFqi1M3ciI" "0:00" "13" "CAPCDV - Mauvaise peau"
dl_video "cest-arrive" "anniversaire" "https://www.youtube.com/watch?v=k0JUfaB0MTo" "0:00" "12" "CAPCDV - L'anniversaire"
dl_video "cest-arrive" "veilleur_de_nuit" "https://www.youtube.com/watch?v=HtH_Hosomok" "0:00" "13" "CAPCDV - Veilleur de nuit"

echo ""
echo "======================================"
echo "🎉 Vidéos terminées:"
find "$OUTDIR" -name "*.mp4" | sort | while read f; do
  echo "  $(du -h "$f" | cut -f1)  $(basename $(dirname "$f"))/$(basename "$f")"
done
echo ""
echo "Total MP3: $(find "$OUTDIR" -name "*.mp3" | wc -l) | Total MP4: $(find "$OUTDIR" -name "*.mp4" | wc -l)"

openclaw system event --text "Done: vidéos movie-clips terminées, prêt pour push GitHub" --mode now 2>/dev/null || true
