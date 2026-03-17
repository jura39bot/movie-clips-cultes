#!/usr/bin/env bash
# Script de téléchargement d'extraits audio cultes
set -euo pipefail

OUTDIR="/root/clawd/movie-clips/clips"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[..] $1${NC}"; }
err() { echo -e "${RED}[ERR]${NC} $1"; }

# Fonction: télécharger un extrait YouTube en MP3
# $1=dossier $2=nom_fichier $3=url $4=start $5=durée $6=description
dl_clip() {
  local folder="$1"
  local name="$2"
  local url="$3"
  local start="$4"
  local duration="$5"
  local desc="$6"
  local outfile="$OUTDIR/$folder/${name}.mp3"

  if [ -f "$outfile" ]; then
    log "Déjà présent: $name"
    return
  fi

  warn "Téléchargement: $desc"
  
  # Télécharger l'audio brut
  local tmpfile="/tmp/clip_${name}_raw"
  yt-dlp -f "bestaudio" \
    --no-playlist \
    -o "${tmpfile}.%(ext)s" \
    "$url" \
    --quiet 2>/dev/null || {
      err "Échec download: $desc"
      return
    }

  # Trouver le fichier téléchargé
  local rawfile
  rawfile=$(ls "${tmpfile}".* 2>/dev/null | head -1)
  if [ -z "$rawfile" ]; then
    err "Fichier non trouvé: $desc"
    return
  fi

  # Extraire l'extrait en MP3
  ffmpeg -y -ss "$start" -t "$duration" \
    -i "$rawfile" \
    -vn -acodec libmp3lame -q:a 4 \
    "$outfile" \
    -loglevel quiet 2>/dev/null || {
      err "Échec ffmpeg: $desc"
      rm -f "$rawfile"
      return
    }

  rm -f "$rawfile"
  log "✓ $desc → $(du -h "$outfile" | cut -f1)"
}

echo ""
echo "🎬 Téléchargement des extraits cultes"
echo "======================================"
echo ""

# ===========================================
# DIKKENEK (2006)
# ===========================================
echo "🇧🇪 DIKKENEK"

dl_clip "dikkenek" "au_bar_comment_il_est_a_laise" \
  "https://www.youtube.com/watch?v=tWjdz8A1KLU" \
  "0:00" "14" \
  "Dikkenek - Comment il est à l'aise lui"

dl_clip "dikkenek" "fricadelle" \
  "https://www.youtube.com/watch?v=N7KrCafIz1A" \
  "0:00" "13" \
  "Dikkenek - La fricadèlle"

dl_clip "dikkenek" "tu_ne_me_vois_pas" \
  "https://www.youtube.com/watch?v=QVEZG9PnEqo" \
  "0:00" "13" \
  "Dikkenek - Tu ne me vois pas?!"

dl_clip "dikkenek" "carjacking" \
  "https://www.youtube.com/watch?v=-FJfc2qtvJU" \
  "0:00" "12" \
  "Dikkenek - Carjacking"

dl_clip "dikkenek" "tendu_natasha" \
  "https://www.youtube.com/watch?v=l_J4NYm5-Po" \
  "0:00" "13" \
  "Dikkenek - T'es tendu Natasha"

# ===========================================
# BERNIE (1996)
# ===========================================
echo ""
echo "🎭 BERNIE"

dl_clip "bernie" "assaut_a_la_pelle" \
  "https://www.youtube.com/watch?v=61lwMjuZm5o" \
  "0:00" "13" \
  "Bernie - L'assaut à la pelle (Dupontel)"

dl_clip "bernie" "vous_vous_promenez" \
  "https://www.youtube.com/watch?v=liIjlXguUFY" \
  "0:00" "14" \
  "Bernie - Vous vous promenez?"

dl_clip "bernie" "scene_magasin" \
  "https://www.youtube.com/watch?v=YBkNdptTiqQ" \
  "0:00" "13" \
  "Bernie - Scène du magasin"

dl_clip "bernie" "noel" \
  "https://www.youtube.com/watch?v=4OBQq8gqwDU" \
  "0:00" "12" \
  "Bernie - Noël"

# ===========================================
# LA 7ÈME COMPAGNIE
# ===========================================
echo ""
echo "🪖 LA 7ÈME COMPAGNIE"

dl_clip "7eme-compagnie" "allo_eglantine_ici_mirabelle" \
  "https://www.youtube.com/watch?v=bEdU0wS0bqo" \
  "0:00" "14" \
  "7e Cie - Allô Eglantine ici Mirabelle"

dl_clip "7eme-compagnie" "trop_charge" \
  "https://www.youtube.com/watch?v=C9FguLg1_UA" \
  "0:00" "13" \
  "7e Cie - Évidemment il est trop chargé"

dl_clip "7eme-compagnie" "falzar" \
  "https://www.youtube.com/watch?v=1KdptN97WZU" \
  "0:00" "12" \
  "7e Cie - Tassin donne ton falzar"

dl_clip "7eme-compagnie" "repliques_cultes" \
  "https://www.youtube.com/watch?v=2lZiDS_1AR0" \
  "0:00" "15" \
  "7e Cie - Compilation répliques"

dl_clip "7eme-compagnie" "chateau_vieux" \
  "https://www.youtube.com/watch?v=Jlv00M_MXVc" \
  "0:00" "13" \
  "7e Cie - Château vieux"

# ===========================================
# LA CITÉ DE LA PEUR (1994)
# ===========================================
echo ""
echo "🐧 LA CITÉ DE LA PEUR"

dl_clip "cite-de-la-peur" "simon_jeremy" \
  "https://www.youtube.com/watch?v=21-4kI9hv50" \
  "0:00" "14" \
  "Cité de la Peur - Simon Jérémy"

dl_clip "cite-de-la-peur" "tu_bluffes_martoni" \
  "https://www.youtube.com/watch?v=tNeig1leks8" \
  "0:00" "14" \
  "Cité de la Peur - Tu bluffes Martoni!"

dl_clip "cite-de-la-peur" "bout_de_pomme_de_terre" \
  "https://www.youtube.com/watch?v=VNtQmMveA7I" \
  "0:00" "13" \
  "Cité de la Peur - Bout de pomme de terre"

dl_clip "cite-de-la-peur" "hippo_ou_elephant" \
  "https://www.youtube.com/watch?v=Mzz6-A7U3JU" \
  "0:00" "14" \
  "Cité de la Peur - Hippo ou éléphant?"

dl_clip "cite-de-la-peur" "quand_je_suis_content_je_vomis" \
  "https://www.youtube.com/watch?v=NSx2tSfh3p4" \
  "0:00" "13" \
  "Cité de la Peur - Quand je suis content je vomis"

dl_clip "cite-de-la-peur" "aeroport_nice" \
  "https://www.youtube.com/watch?v=wEW1S1P_Umk" \
  "0:00" "14" \
  "Cité de la Peur - Aéroport de Nice"

# ===========================================
# C'EST ARRIVÉ PRÈS DE CHEZ VOUS (1992)
# ===========================================
echo ""
echo "📷 C'EST ARRIVÉ PRÈS DE CHEZ VOUS"

dl_clip "cest-arrive" "petit_gregory" \
  "https://www.youtube.com/watch?v=TtyEhDgXNX4" \
  "0:00" "13" \
  "CAPCDV - Petit Gregory"

dl_clip "cest-arrive" "comment_lester_un_corps" \
  "https://www.youtube.com/watch?v=gGBaK3aSgkQ" \
  "0:00" "14" \
  "CAPCDV - Comment lester un corps"

dl_clip "cest-arrive" "mauvaise_peau" \
  "https://www.youtube.com/watch?v=BkFqi1M3ciI" \
  "0:00" "13" \
  "CAPCDV - Tu vas me soigner cette mauvaise peau"

dl_clip "cest-arrive" "anniversaire" \
  "https://www.youtube.com/watch?v=k0JUfaB0MTo" \
  "0:00" "12" \
  "CAPCDV - L'anniversaire"

dl_clip "cest-arrive" "veilleur_de_nuit" \
  "https://www.youtube.com/watch?v=HtH_Hosomok" \
  "0:00" "13" \
  "CAPCDV - Veilleur de nuit"

echo ""
echo "======================================"
echo "🎉 Terminé! Voici les fichiers créés:"
echo ""
find "$OUTDIR" -name "*.mp3" | sort | while read f; do
  echo "  $(du -h "$f" | cut -f1)  $(basename $(dirname "$f"))/$(basename "$f")"
done

echo ""
echo "Total: $(find "$OUTDIR" -name "*.mp3" | wc -l) extraits MP3"

# Notifier l'agent
openclaw system event --text "Done: Repo movie-clips prêt avec $(find "$OUTDIR" -name "*.mp3" | wc -l) extraits MP3 cultes" --mode now 2>/dev/null || true
