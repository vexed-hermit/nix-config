{ pkgs, ... }:

{
  # ---- Dependencies ----
  home.packages = with pkgs; [
    ffmpeg-full   # audio extraction, thumbnail/metadata embedding
    aria2         # multi-connection downloader
    atomicparsley # embeds metadata/thumbnails into m4a/mp4 audio containers
  ];

  # ---- yt-dlp ----
  programs.yt-dlp = {
    enable = true;

    settings = {
      # --- Audio-only extraction (default behavior) ---
      extract-audio = true;
      audio-format = "mp3";       # or "best" to keep source codec (opus/m4a) without lossy re-encode
      audio-quality = "0";        # best quality (VBR ~245kbps for mp3)
      format = "bestaudio/best";

      # --- Output & organization ---
      output = "~/Music/%(uploader)s/%(title)s [%(id)s].%(ext)s";
      restrict-filenames = true;
      trim-filenames = 150;

      # --- Subtitles (sidecar files, since audio can't embed them) ---
      write-subs = true;
      write-auto-subs = true;
      sub-langs = "en.*";
      convert-subs = "srt";

      # --- Metadata & thumbnails (these DO embed into audio) ---
      embed-metadata = true;
      embed-thumbnail = true;
      add-metadata = true;
      parse-metadata = "%(release_date,upload_date)s:%(meta_date)s";

      # --- Downloader ---
      downloader = "aria2c";
      downloader-args = "aria2c:-x 16 -s 16 -k 1M";

      # --- Reliability ---
      retries = 10;
      fragment-retries = 10;
      continue = true;
      no-overwrites = true;
      concurrent-fragments = 4;

      # --- Archive tracking ---
      download-archive = "~/Music/.yt-dlp-archive.txt";
    };
  };
}
