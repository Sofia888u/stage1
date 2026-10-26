/**Dictionnaire des noms possibles pour chaque feuille*/
var SHEETS_ = {
  ncs: ["Table_NCs", "Table NCs", "NCs"],
  details: ["Table_Détails", "Table_Details", "Table1"],
  medias: ["Table_Médias", "Table_Medias", "Table2"],
  types: ["Table_Types", "Table Types", "Types"],
  analyses: ["Table_Analyses", "Table Analyses", "Analyses", "Table4"],
  tracabilites: ["Table_Tracabilites", "Table_Traçabilités", "Table Tracabilites"]
};

// Colonnes candidates par champ variable (ordre de priorité)
var FIELD_ALIASES_ = {
  process: [
    "process concerne", "processus concerne", "process concerné",
    "process detection", "process détection", "departement", "département",
    "process", "processus"
  ],
  machine: ["machine"],
  // Origine = type NC dans Table_Types (cle N° NC)
  origine: [
    "quel est le type de la non conformite",
    "type de la non conformite",
    "type nc", "type", "origine"
  ],
  client: ["client"],
  // Anomalie : colonne de Table_NCs, affichée entre le titre et le client
  anomalie: ["anomalie"],
  article: ["article"],
  date: ["date"],
  qteNcs: ["quantite non conforme", "quantite nc", "qte non conforme"],
  qteDet: ["quantite kg", "quantite (kg)", "quantite"],
  lien: ["lien", "url", "photo", "image", "link"],
  // NB : colonne Commentaires (souvent vide -> on laisse vide)!!
  commentaires: ["commentaires", "commentaire", "comment"],
  nc: ["n nc", "n° nc", "nc", "code"]
};

// Nombre max de fiches conseillé avant avertissement
var MAX_SELECTION_ = 15;

var TRIANGLE_PNG_B64_ =  //Base64
  "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";
/** Crée le menu "point.qualite" dans la barre de menus du tableur à l'ouverture!!!!!!!!! */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu("point.qualite")
    .addItem("Afficher en popup ", "afficherFichePopup")
    .addItem("Créer une nouvelle feuille", "genererFicheAffichage")
    .addToUi();
}
/** Affiche une alerte à l'utilisateur , si l'UI n'est pas disponible , écrit dans les logs à la place */
function alertSafe_(msg) {
  try { SpreadsheetApp.getUi().alert(msg); }
  catch (e) { Logger.log(msg); }
}

/** Echappe les caractères spéciaux HTML (&, <, >, ") pour un affichage sur dans le popup !!! */
function esc_(s) {
  return String(s == null ? "" : s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

/** Normalise un intitulé de colonne (minuscules, sans accents, sans ponctuation) pour pouvoir comparer des en-têtes écrits différemment */
function normHeader_(s) {
  return String(s || "")
    .toLowerCase()      //minuscules
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")   //é -> e, è -> e
    .replace(/n[°º]/g, "n")  //N° ou ° -> n
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

/** Cherche une feuille par une liste de noms possibles  tolère les variations de nommage */
function getSheetFlex_(names) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var i, sh;
  for (i = 0; i < names.length; i++) {
    sh = ss.getSheetByName(names[i]);
    if (sh) return sh;
  }
  var all = ss.getSheets();
  var targets = names.map(normHeader_);
  for (i = 0; i < all.length; i++) {
    if (targets.indexOf(normHeader_(all[i].getName())) !== -1) return all[i];
  }
  return null;
}

/** Trouve l'index (0-based) de la colonne correspondant à l'un des alias donnés, par correspondance exacte puis partielle */
function colIndex_(headers, aliases) {
  var norms = headers.map(normHeader_);
  var i, j, a;
  for (i = 0; i < aliases.length; i++) {
    a = normHeader_(aliases[i]);
    j = norms.indexOf(a);
    if (j >= 0) return j;
  }
  for (i = 0; i < aliases.length; i++) {
    a = normHeader_(aliases[i]);
    if (!a) continue;
    for (j = 0; j < norms.length; j++) {
      if (norms[j].indexOf(a) !== -1) return j;
    }
  }
  return -1;
}

/** Convertit la valeur d'une cellule en texte propre (les dates sont formatées en dd/MM/yyyy) */
function cellStr_(v) {
  if (v === null || v === undefined || v === "") return "";
  if (v instanceof Date) {
    return Utilities.formatDate(v, Session.getScriptTimeZone(), "dd/MM/yyyy");
  }
  return String(v).trim();
}

/** Normalise un N° NC pour la comparaison entre tables (espaces retirés, zéros de tête ignorés) : fait correspondre "3092605", " 3092605 " et "03092605". */
function normNc_(v) {
  var s = String(v == null ? "" : v).trim().replace(/[\s\u00A0]+/g, "");
  if (/^\d+$/.test(s)) s = String(parseInt(s, 10));
  return s;
}

/** Détecte automatiquement la ligne d'en-tête d'une table en cherchant la colonne "N° NC" parmi les 15 premières lignes */
function findHeaderRow_(values) {
  var r, c, n;
  var max = Math.min(values.length, 15);
  for (r = 0; r < max; r++) {
    for (c = 0; c < values[r].length; c++) {
      n = normHeader_(values[r][c]);
      if (n === "n nc" || n.indexOf("n nc") !== -1) return r;
    }
  }
  return 0;
}

/** Lit toute une table (une des Table_...) et l'indexe par N° NC pour un accès rapide (byNc) */
function lireTable_(sheetNames, refKeys) {
  var sh = getSheetFlex_(sheetNames);
  if (!sh) return { byNc: {}, headers: [], sheet: null };
  var lastRow = sh.getLastRow();
  var lastCol = sh.getLastColumn();
  if (lastRow < 1 || lastCol < 1) return { byNc: {}, headers: [], sheet: sh };
  var values = sh.getRange(1, 1, lastRow, lastCol).getValues();
  var hRow = findHeaderRow_(values);
  var headers = values[hRow];
  var iNc = colIndex_(headers, FIELD_ALIASES_.nc);
  // Détection par contenu : si un autre colonne contient plus de N° NC connus (Table_NCs), on la préfère à l'en-tête.
  if (refKeys) iNc = meilleureColonneNc_(values, hRow, iNc, refKeys);
  var byNc = {};
  var r, nc, obj, c, key;
  for (r = hRow + 1; r < values.length; r++) {
    nc = normNc_(values[r][iNc < 0 ? 1 : iNc]);
    if (!nc) continue;
    obj = { _row: r + 1, _nc: nc };
    // _next = cellule juste à droite du N° NC (sert de repli pour "origine" si les en-têtes sont décalés)
    obj._next = values[r][(iNc < 0 ? 1 : iNc) + 1];
    for (c = 0; c < headers.length; c++) {
      key = normHeader_(headers[c]);
      if (!key) continue;
      obj[key] = values[r][c];
    }
    byNc[nc] = obj; // dernière ligne gagne si doublons
  }
  return { byNc: byNc, headers: headers, sheet: sh, headerRow: hRow, ncCol: iNc };
}

/** Retourne l'index de la colonne qui contient le plus de N° NC connus (refKeys) ; garde celle de l'en-tête si elle est aussi bonne. */
function meilleureColonneNc_(values, hRow, iNcHeader, refKeys) {
  var nCols = values[hRow].length;
  var best = iNcHeader, bestCount = -1;
  var c, r, count, k;
  var counts = [];
  for (c = 0; c < nCols; c++) {
    count = 0;
    for (r = hRow + 1; r < values.length; r++) {
      k = normNc_(values[r][c]);
      if (k && refKeys[k]) count++;
    }
    counts[c] = count;
  }
  var headerCount = iNcHeader >= 0 ? counts[iNcHeader] : 0;
  for (c = 0; c < nCols; c++) {
    if (counts[c] > bestCount) { bestCount = counts[c]; best = c; }
  }
  if (bestCount > headerCount) return best;
  return iNcHeader;
}

/** Première valeur non vide parmi aliases dans une row */
function val_(row, aliases) {
  if (!row) return "";
  var i, k;
  for (i = 0; i < aliases.length; i++) {
    k = normHeader_(aliases[i]);
    if (row[k] !== undefined && row[k] !== null && String(row[k]).trim() !== "") {
      return row[k];
    }
  }
  return "";
}

/**
 * VARIABLE : cherche un champ dans plusieurs rows (tables),
 * dans l'ordre. Première valeur non vide gagne.
 * rows = [rowNcs, rowDetails, rowTypes, ...]
 */
function firstVal_(rows, aliases) {
  var i, v;
  for (i = 0; i < rows.length; i++) {
    v = val_(rows[i], aliases);
    if (cellStr_(v) !== "") return v;
  }
  return "";
}

/** Extrait l'identifiant Google Drive d'un lien (URL /d/..., ?id=..., ou ID brut) */
function extraireDriveId_(url) {
  var s = String(url || "").trim();
  if (!s) return "";
  var m = s.match(/\/d\/([a-zA-Z0-9_-]{20,})/)
    || s.match(/[?&]id=([a-zA-Z0-9_-]{20,})/)
    || s.match(/open\?id=([a-zA-Z0-9_-]{20,})/);
  if (m) return m[1];
  if (/^[a-zA-Z0-9_-]{25,}$/.test(s)) return s;
  return "";
}

/** Récupère une version réduite de la photo Drive pour limiter la taille  */
function getBlobImageReduit_(fileId) {
  var headers = { Authorization: "Bearer " + ScriptApp.getOAuthToken() };
  var sizes = ["w500", "s400", "w300"];
  var i, url, resp;
  for (i = 0; i < sizes.length; i++) {
    url = "https://drive.google.com/thumbnail?sz=" + sizes[i] + "&id=" + fileId;
    resp = UrlFetchApp.fetch(url, { headers: headers, muteHttpExceptions: true });
    if (resp.getResponseCode() === 200) {
      return resp.getBlob().setName("photo.jpg").setContentType("image/jpeg");
    }
  }
  return DriveApp.getFileById(fileId).getBlob();
}

/** Convertit un blob image en data URL base64 utilisable directement dans une balise <img>. */
function blobToDataUrl_(blob) {
  return "data:" + blob.getContentType() + ";base64," + Utilities.base64Encode(blob.getBytes());
}

/** Récupère la data URL de la photo à partir du lien Drive stocké dans Table_Médias, pour l'affichage dans le popup. */
function getPhotoDataUrl_(lien) {
  var fileId = extraireDriveId_(lien);
  if (!fileId) return "";
  try { return blobToDataUrl_(getBlobImageReduit_(fileId)); }
  catch (e) {
    try { return blobToDataUrl_(DriveApp.getFileById(fileId).getBlob()); }
    catch (e2) { Logger.log(e2); return ""; }
  }
}

/** Reconstruit l'image du triangle d'avertissement à partir des données encodées en base64 (pas de fichier Drive nécessaire). */
function getTriangleBlob_() {
  var bytes = Utilities.base64Decode(TRIANGLE_PNG_B64_);
  return Utilities.newBlob(bytes, "image/png", "triangle.png");
}

/** Dessine le triangle d'avertissement en SVG (utilisé uniquement dans le popup, jamais sur la feuille). */
function triangleSvg_() {
  return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="58" height="58">' +
    '<polygon points="32,6 58,54 6,54" fill="#b71c1c"/>' +
    '<polygon points="32,12 53,50 11,50" fill="#e53935"/>' +
    '<rect x="29.5" y="22" width="5" height="17" rx="1.5" fill="#fff"/>' +
    '<circle cx="32" cy="46" r="3" fill="#fff"/>' +
    '</svg>';
}

/** Formate la quantité en "=> Environ X kg" (ajoute "kg" seulement si absent de la valeur d'origine). */
function formatKg_(q) {
  var s = cellStr_(q);
  if (!s) return "";
  if (/kg/i.test(s)) return "=> Environ " + s;
  return "=> Environ " + s + " kg";
}

/**
 * Titre fiche selon ORIGINE (variable).
 * - si origine contient "reclam" → Réclamation Client (CLIENT):
 * - sinon → Origine (CLIENT):  ex: Interne (CLIENT):
 * - si pas d'origine → Réclamation Client (CLIENT):
 */
function titreFiche_(origine, client) {
  var c = cellStr_(client).toUpperCase() || "CLIENT";
  var o = cellStr_(origine);
  // Origine vide (pas de match N° NC dans Table_Types) -> titre vide, pas de défaut forcé.
  if (!o) return "";
  if (/reclam/i.test(o)) {
    return "Réclamation Client (" + c + "):";
  }
  return o + " (" + c + "):";
}

/**
 * Assemble la fiche pour un N° NC.
 * Process / Machine / Origine = variables multi-tables.
 */
function assemblerFiche_(nc) {
  var ncsT = lireTable_(SHEETS_.ncs);
  var detT = lireTable_(SHEETS_.details, ncsT.byNc);
  var medT = lireTable_(SHEETS_.medias, ncsT.byNc);
  var typT = lireTable_(SHEETS_.types, ncsT.byNc);
  var anaT = lireTable_(SHEETS_.analyses, ncsT.byNc);
  var traT = lireTable_(SHEETS_.tracabilites, ncsT.byNc);

  var ncs = ncsT.byNc[nc];
  if (!ncs) return null;

  var det = detT.byNc[nc] || null;
  var med = medT.byNc[nc] || null;
  var typ = typT.byNc[nc] || null;
  var ana = anaT.byNc[nc] || null;
  var tra = traT.byNc[nc] || null;

  // Process & Machine : NCs puis Détails puis Traçabilités (première valeur non vide)
  var rowsProcMach = [ncs, det, tra];
  // Origine : uniquement Table_Types (matché par N° NC), pas de repli sur Table_NCs.
  var rowsOrigine = [typ];
  // NB / Commentaires : Détails → Analyses → Types → Traçabilités (souvent vide)
  var rowsNb = [det, ana, typ, tra];

  var process = cellStr_(firstVal_(rowsProcMach, FIELD_ALIASES_.process));
  var machine = cellStr_(firstVal_(rowsProcMach, FIELD_ALIASES_.machine));
  var origine = cellStr_(firstVal_(rowsOrigine, FIELD_ALIASES_.origine));
  // Repli : en-têtes décalés dans Table_Types -> le type est dans la cellule à droite du N° NC.
  if (!origine && typ) origine = cellStr_(typ._next);
  var nb = cellStr_(firstVal_(rowsNb, FIELD_ALIASES_.commentaires));

  // Client uniquement Table_NCs
  var client = cellStr_(val_(ncs, FIELD_ALIASES_.client));
  var article = cellStr_(val_(ncs, FIELD_ALIASES_.article));
  var anomalie = cellStr_(val_(ncs, FIELD_ALIASES_.anomalie));
  var dateNc = val_(ncs, FIELD_ALIASES_.date);
  var qte = val_(ncs, FIELD_ALIASES_.qteNcs);
  if (cellStr_(qte) === "") qte = val_(det, FIELD_ALIASES_.qteDet);
  var lien = cellStr_(val_(med, FIELD_ALIASES_.lien));

  return {
    nc: nc,
    date: cellStr_(dateNc) || "-",
    client: client,
    article: article,
    anomalie: anomalie,
    quantite: cellStr_(qte),
    kgLine: formatKg_(qte),
    machine: machine,
    process: process,
    departement: process,
    origine: origine,
    titre: titreFiche_(origine, client),
    nb: nb,
    lien: lien
  };
}

/** Lit un ou plusieurs N° NC depuis la sélection active ; sinon, repli sur le prompt manuel */
function ncsDepuisSelection_() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sh = ss.getActiveSheet();
  var range = sh.getActiveRange();
  var lastCol = Math.max(sh.getLastColumn(), 1);
  var lastRow = Math.max(sh.getLastRow(), 1);
  var values = sh.getRange(1, 1, lastRow, lastCol).getValues();
  var hRow = findHeaderRow_(values);
  var headers = values[hRow];
  var iNc = colIndex_(headers, FIELD_ALIASES_.nc);

  var ncs = [];
  if (iNc >= 0 && range) {
    var r0 = range.getRow();
    var nRows = range.getNumRows();
    var r, v;
    for (r = r0; r < r0 + nRows; r++) {
      if (r <= hRow) continue; // on ignore la ligne d'en-tête elle-même
      if (r > lastRow) break;
      v = normNc_(sh.getRange(r, iNc + 1).getValue());
      if (v && ncs.indexOf(v) === -1) ncs.push(v);
    }
  }

  if (ncs.length > 0) return ncs;

  // Repli : aucune ligne exploitable sélectionnée → demande manuelle (comme avant)
  try {
    var ui = SpreadsheetApp.getUi();
    var r2 = ui.prompt(
      "Affichage Point Qualité",
      "N° NC (exemple : 7092601)",
      ui.ButtonSet.OK_CANCEL
    );
    if (r2.getSelectedButton() !== ui.Button.OK) return [];
    var nc = normNc_(r2.getResponseText());
    return nc ? [nc] : [];
  } catch (e) {
    alertSafe_("Sélectionnez une ou plusieurs lignes avec un N° NC, ou relancez depuis le tableur.");
    return [];
  }
}

/** Si plus de MAX_SELECTION_ N° NC sont sélectionnés, demande confirmation (Oui = tout garder, Non = garder les 15 premiers, Annuler = ne rien faire). */
function confirmerSelection_(ncs) {
  if (ncs.length <= MAX_SELECTION_) return ncs;

  var ui = SpreadsheetApp.getUi();
  var msg =
    "Vous avez sélectionné " + ncs.length + " fiches, ce qui dépasse le maximum conseillé (" +
    MAX_SELECTION_ + ").\n\n" +
    "Voulez-vous continuer avec toutes les fiches, ou vous arrêter aux " + MAX_SELECTION_ + " premières ?\n\n" +
    "Oui = continuer avec toutes les fiches (" + ncs.length + ")\n" +
    "Non = continuer avec les " + MAX_SELECTION_ + " premières seulement\n" +
    "Annuler = tout annuler, ne rien générer";
  var r = ui.alert("Limite de sélection dépassée", msg, ui.ButtonSet.YES_NO_CANCEL);

  if (r === ui.Button.YES) return ncs;
  if (r === ui.Button.NO) return ncs.slice(0, MAX_SELECTION_);
  return null; // Annulé
}

/** Construit les données de toutes les fiches sélectionnées */
function lireFichesActives_() {
  var ncs = ncsDepuisSelection_();
  if (!ncs.length) return null;

  ncs = confirmerSelection_(ncs);
  if (!ncs) return null; // annulé par l'utilisateur

  var out = [];
  var i, data;
  for (i = 0; i < ncs.length; i++) {
    data = assemblerFiche_(ncs[i]);
    if (data) out.push(data);
    else Logger.log("N° NC introuvable dans Table_NCs : " + ncs[i]);
  }

  if (!out.length) {
    alertSafe_("Aucun des N° NC sélectionnés n'a été trouvé dans Table_NCs.");
    return null;
  }
  return out;
}

/** Styles CSS du popup (couleurs, tailles de police, mise en page, zoom photo/lightbox) */
function cssFiche_() {
  return ""
    + "body { font-family: Arial, sans-serif; margin: 16px; background: #f4f4f4; }"
    + ".card { background: #fff; margin: 0 0 22px 0; }"
    + "table.fiche { width: 100%; border-collapse: collapse; background: #fff; }"
    + "th, td { border: 1px solid #333; }"
    + "th { padding: 8px; color: #000; }"
    + "table.meta { width: 100%; border-collapse: collapse; margin-bottom: 12px; }"
    + "table.meta th { background: #d9d9d9; font-size: 11px; font-weight: 700; padding: 6px 4px; }"
    + "table.meta td { text-align: center; font-weight: 600; padding: 6px 3px; font-size: 12px; }"
    + "table.fiche th { background: #cccccc; }"
    + ".wrap { display: flex; min-height: 420px; }"
    + ".photo { width: 48%; display:flex; align-items:center; justify-content:center; border-right:1px solid #333; padding:10px; }"
    + ".photo img { cursor: zoom-in; }"
    + ".txt { width: 52%; padding: 16px 16px 12px 16px; position: relative; display: flex; flex-direction: column; }"
    + ".titre { color:#CC0000; font-weight:700; text-decoration:underline; font-size:20px; margin: 0 0 28px 0; }"
    + ".anomalie { font-weight:700; text-decoration:underline; font-size:15px; margin: 0 0 22px 0; }"
    + ".client { font-weight:700; font-size:15px; margin: 0 0 18px 0; }"
    + ".article { font-weight:700; font-size:14px; margin: 0 0 34px 0; line-height: 1.4; word-break: break-word; }"
    + ".kg { color:#CC0000; font-weight:700; font-size:22px; margin: 0 0 18px 0; }"
    + ".nb { color:#CC0000; font-weight:700; font-size:16px; margin: 8px 0 0 0; }"
    + ".tri { display: flex; justify-content: center; align-items: center; margin: 12px 0 8px 0; }"
    + ".date, .ref { text-align:center; }"
    + ".ref { font-size: 12px; font-weight: 500; width: 140px; }"
    + ".date { width: 120px; font-size: 11px; font-weight: 500; }"
    + "button { margin: 0 0 16px 0; background:#1a73e8; color:#fff; border:0; padding:8px 16px; border-radius:4px; cursor:pointer; }"
    // NOUVEAU : zoom photo (lightbox) dans le popup
    + "#lightboxOverlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.85); z-index:1000; align-items:center; justify-content:center; }"
    + "#lightboxOverlay.open { display:flex; }"
    + "#lightboxOverlay img { max-width:92%; max-height:92%; box-shadow:0 0 24px rgba(0,0,0,0.6); }"
    + "#lightboxClose { position:fixed; top:14px; right:20px; width:34px; height:34px; border-radius:50%; background:#fff; color:#333; font-size:20px; font-weight:700; line-height:34px; text-align:center; cursor:pointer; z-index:1001; }"
    + "@media print { body { background:#fff; margin:0; } button, #lightboxOverlay { display:none; } .card { page-break-after: always; margin:0; } }";
}

/** Construit le HTML d'une fiche (une "card") pour le popup : en-têtes, photo cliquable (zoom), titre, client, article, quantité, triangle, NB */
function buildCardHtml_(d, photo) {
  var photoHtml = photo
    // NOUVEAU : clic sur la photo -> zoom (lightbox) plein popup
    ? '<img src="' + photo + '" style="max-width:100%;max-height:400px;" onclick="ouvrirLightbox_(this.src)">'
    : '<div style="color:#888;">Image non trouvée</div>';
  var dateMaj = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), "dd/MM/yyyy");

  return ""
    + '<div class="card">'
    + '<table class="meta"><tr>'
    + "<th>Date mise à jour</th><th>Département</th><th>Machine</th>"
    + "</tr><tr>"
    + "<td>" + esc_(dateMaj) + "</td>"
    + "<td>" + esc_(d.process) + "</td>"
    + "<td>" + esc_(d.machine) + "</td>"
    + "</tr></table>"
    + '<table class="fiche"><tr>'
    + "<th>Date</th><th>Description du problème constaté</th><th>Référence interne</th>"
    + "</tr><tr>"
    + '<td class="date">' + esc_(d.date) + "</td>"
    + "<td><div class=\"wrap\">"
    + '<div class="photo">' + photoHtml + "</div>"
    + '<div class="txt">'
    + '<div class="titre">' + esc_(d.titre) + "</div>"
    + (d.anomalie ? '<div class="anomalie">' + esc_(d.anomalie) + "</div>" : "")
    + '<div class="client">' + esc_(d.client) + "</div>"
    + '<div class="article">' + esc_(d.article) + "</div>"
    + (d.kgLine ? '<div class="kg">' + esc_(d.kgLine) + "</div>" : "")
    + '<div class="tri">' + triangleSvg_() + "</div>"
    + (d.nb ? '<div class="nb">NB : ' + esc_(d.nb) + "</div>" : "")
    + "</div></div></td>"
    + '<td class="ref">' + esc_(d.nc) + "</td>"
    + "</tr></table></div>";
}

/** Affiche le popup (sélection multiple, une carte empilée par fiche) avec zoom photo */
function afficherFichePopup() {
  try {
    var dataList = lireFichesActives_();
    if (!dataList) return;

    var cardsHtml = dataList.map(function (d) {
      return buildCardHtml_(d, getPhotoDataUrl_(d.lien));
    }).join("");

    var lightboxHtml =
      '<div id="lightboxOverlay" onclick="fermerLightbox_(event)">' +
      '<span id="lightboxClose" onclick="fermerLightbox_(event)">&times;</span>' +
      '<img id="lightboxImg" src="">' +
      '</div>' +
      '<script>' +
      'function ouvrirLightbox_(src){' +
      'document.getElementById("lightboxImg").src = src;' +
      'document.getElementById("lightboxOverlay").classList.add("open");' +
      '}' +
      'function fermerLightbox_(e){' +
      'e.stopPropagation();' +
      'document.getElementById("lightboxOverlay").classList.remove("open");' +
      '}' +
      '</script>';

    var html = HtmlService.createHtmlOutput(
      "<!DOCTYPE html><html><head><base target='_top'><style>" + cssFiche_() + "</style></head><body>" +
      cardsHtml +
      lightboxHtml +
      '<button onclick="window.print()">Imprimer</button></body></html>'
    ).setWidth(980).setHeight(720);

    var titre = dataList.length > 1
      ? "Affichage Point Qualité (" + dataList.length + " fiches)"
      : "Affichage Point Qualité";
    SpreadsheetApp.getUi().showModalDialog(html, titre);
  } catch (e) {
    alertSafe_("Erreur popup : " + e.message);
    Logger.log(e);
  }
}

/** Insère la photo dans la feuille "Affichage_..." à la cellule donnée , affiche un message si le lien est invalide ou l'image introuvable */
function insererPhotoFeuille_(sh, lien, col, row) {
  var fileId = extraireDriveId_(lien);
  if (!fileId) {
    sh.getRange(row, col).setValue("[Image non trouvée]")
      .setHorizontalAlignment("center").setVerticalAlignment("middle");
    return;
  }
  try {
    var blob = getBlobImageReduit_(fileId);
    sh.insertImage(blob, col, row, 8, 15).setWidth(340).setHeight(420);
  } catch (e) {
    sh.getRange(row, col)
      .setValue("[Erreur image] " + e.message)
      .setHorizontalAlignment("center")
      .setVerticalAlignment("middle")
      .setWrap(true);
  }
}

/** Insère le triangle d'avertissement dans la feuille, en bas à droite de la cellule (col, row)*/
function insererTriangle_(sh, col, row) {
  try {
    sh.insertImage(getTriangleBlob_(), col, row, 165, 300).setWidth(50).setHeight(50);
  } catch (e) {
    Logger.log(e);
  }
}

/** Écrit le bandeau "Date mise à jour / Département / Machine" en haut d'une fiche, sur 2 lignes (row et row+1) */
function ecrireEnteteMeta_(sh, row, bold, headerBg, data) {
  sh.getRange(row, 1).setValue("Date mise à jour").setTextStyle(bold).setBackground(headerBg)
    .setHorizontalAlignment("center").setBorder(true, true, true, true, null, null);
  sh.getRange(row, 2).setValue("Département").setTextStyle(bold).setBackground(headerBg)
    .setHorizontalAlignment("center").setBorder(true, true, true, true, null, null);
  sh.getRange(row, 3).setValue("Machine").setTextStyle(bold).setBackground(headerBg)
    .setHorizontalAlignment("center").setBorder(true, true, true, true, null, null);

  var dateMaj = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), "dd/MM/yyyy");
  sh.getRange(row + 1, 1).setValue(dateMaj)
    .setHorizontalAlignment("center").setVerticalAlignment("middle")
    .setFontSize(9).setFontWeight("bold")
    .setBorder(true, true, true, true, null, null);
  sh.getRange(row + 1, 2).setValue(data.process || "")
    .setHorizontalAlignment("center").setVerticalAlignment("middle")
    .setFontSize(9).setFontWeight("bold")
    .setBorder(true, true, true, true, null, null);
  sh.getRange(row + 1, 3).setValue(data.machine || "")
    .setHorizontalAlignment("center").setVerticalAlignment("top")
    .setFontSize(9).setFontWeight("bold")
    .setBorder(true, true, true, true, null, null);

  sh.setRowHeight(row, 28);
  sh.setRowHeight(row + 1, 28);
}

/** Ecrit le corps d'une fiche sur la feuille : en-têtes Date/Description/Référence, puis le contenu (date, photo, texte riche titre+client+article+quantité+NB) */
function ecrireFiche_(sh, data, headerRow, contentRow, bold, headerBg) {
  sh.getRange(headerRow, 1).setValue("Date").setTextStyle(bold).setBackground(headerBg)
    .setHorizontalAlignment("center").setBorder(true, true, true, true, null, null);
  sh.getRange(headerRow, 2, 1, 2).merge().setValue("Description du problème constaté")
    .setTextStyle(bold).setBackground(headerBg)
    .setHorizontalAlignment("center").setBorder(true, true, true, true, null, null);
  sh.getRange(headerRow, 4).setValue("Référence interne").setTextStyle(bold)
    .setBackground(headerBg).setHorizontalAlignment("center")
    .setBorder(true, true, true, true, null, null);

  sh.getRange(contentRow, 1).setValue(data.date).setHorizontalAlignment("center")
    .setVerticalAlignment("middle").setBorder(true, true, true, true, null, null);
  sh.getRange(contentRow, 2).setBorder(true, true, true, true, null, null);
  sh.getRange(contentRow, 4).setValue(data.nc).setHorizontalAlignment("center")
    .setVerticalAlignment("middle").setFontSize(8).setFontWeight("bold")
    .setBorder(true, true, true, true, null, null);

  // Espacement : un peu d'air en haut même sans titre, pour que "Client" ne colle pas au bord.
  var strTitre = data.titre ? (data.titre + (data.anomalie ? "\n\n" : "\n\n\n")) : "\n\n";
  var strAnomalie = data.anomalie ? (data.anomalie + "\n\n\n") : "";
  var strClient = (data.client || "") + "\n\n";
  var strArticle = (data.article || "") + "\n\n\n\n";
  var strKg = (data.kgLine || "") + "\n\n\n\n\n"; // place pour le triangle (au milieu)
  var strNb = data.nb ? ("NB : " + data.nb) : "";
  var full = strTitre + strAnomalie + strClient + strArticle + strKg + strNb;

  var redU = SpreadsheetApp.newTextStyle().setForegroundColor("#CC0000").setBold(true).setUnderline(true).setFontSize(15).build();
  // Client / Article / Commentaire (NB) : police fine (normale, pas grasse), un peu agrandie
  var normalBlack = SpreadsheetApp.newTextStyle().setForegroundColor("#000000").setBold(true).setFontSize(11).build();
  var normalRed = SpreadsheetApp.newTextStyle().setForegroundColor("#CC0000").setBold(true).setFontSize(13).build();
  // Quantité (kg) : toujours la plus grande (plus grande que le titre)
  var anomalieStyle = SpreadsheetApp.newTextStyle().setForegroundColor("#000000").setBold(true).setUnderline(true).setFontSize(12).build();
  var redB = SpreadsheetApp.newTextStyle().setForegroundColor("#CC0000").setBold(true).setFontSize(17).build();

  var builder = SpreadsheetApp.newRichTextValue().setText(full);
  var p = 0;
  // Si titre vide, longueur 0 -> ne pas appeler setTextStyle (sinon erreur).
  if (strTitre.length) builder.setTextStyle(p, p + strTitre.length, redU);
  p += strTitre.length;
  if (strAnomalie.length) builder.setTextStyle(p, p + strAnomalie.length, anomalieStyle);
  p += strAnomalie.length;
  builder.setTextStyle(p, p + strClient.length, normalBlack);
  p += strClient.length;
  builder.setTextStyle(p, p + strArticle.length, normalBlack);
  p += strArticle.length;
  var kgEnd = p + strKg.length;
  if (strKg.length) builder.setTextStyle(p, kgEnd, redB);
  if (strNb) builder.setTextStyle(kgEnd, full.length, normalRed);

  sh.getRange(contentRow, 3).setRichTextValue(builder.build())
    .setVerticalAlignment("top").setHorizontalAlignment("left").setWrap(true)
    .setBorder(true, true, true, true, null, null);

  sh.setRowHeight(contentRow, 450);
  insererPhotoFeuille_(sh, data.lien, 2, contentRow);
  insererTriangle_(sh, 3, contentRow); // triangle au milieu du bloc texte, sous la quantité
}

/** Crée UNE feuille "Affichage_..." avec toutes les fiches sélectionnées empilees, a cote de la feuille active */
function genererFicheAffichage() {
  var dataList = lireFichesActives_();
  if (!dataList) return;

  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var feuilleDepart = ss.getActiveSheet();
  var baseIndex = feuilleDepart.getIndex(); // position (1-indexée) de la feuille active

  // Une seule feuille pour toutes les fiches sélectionnées, empilées (comme le popup).
  var name = dataList.length > 1
    ? "Affichage_" + dataList[0].nc + "_+" + (dataList.length - 1)
    : "Affichage_" + dataList[0].nc;

  var sh = ss.getSheetByName(name);
  if (sh) ss.deleteSheet(sh);

  sh = ss.insertSheet(name); // créée en fin de classeur par défaut...
  ss.setActiveSheet(sh);
  ss.moveActiveSheet(baseIndex + 1); // ...puis déplacée juste à côté de la feuille de départ

  sh.setColumnWidth(1, 150);
  sh.setColumnWidth(2, 380);
  sh.setColumnWidth(3, 380);
  sh.setColumnWidth(4, 160);

  var bold = SpreadsheetApp.newTextStyle().setBold(true).build();
  // Couleurs alignées sur le popup (gris), au lieu du bleu utilisé avant.
  var metaBg = "#d9d9d9";
  var ficheBg = "#cccccc";

  var row = 3; // ligne de départ de la première fiche
  var i, data;
  for (i = 0; i < dataList.length; i++) {
    data = dataList[i];

    ecrireEnteteMeta_(sh, row, bold, metaBg, data);          // occupe row et row+1
    ecrireFiche_(sh, data, row + 3, row + 4, bold, ficheBg); // en-tête row+3, contenu row+4

    row += 6; // ligne de départ de la fiche suivante (avec un peu d'espace entre elles)
  }

  ss.setActiveSheet(sh);
}
