require "formula"

class Libdc1394 < Formula
  homepage "http://damien.douxchamps.net/ieee1394/libdc1394/"
  url "https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.2/libdc1394-2.2.2.tar.gz"
  sha1 "13958c3cd0709565b5e4a9012dcf2a9b710264e2"

  bottle do
    cellar :any
    revision 1
    sha1 "289ebcfa4d7aea0740a54c5de50df23018f9d742" => :yosemite
    sha1 "747ac444ec23e13c57ae476d2e1181a2d6c728f0" => :mavericks
    sha1 "68488e8fc4d387b6dc63e95dba4c26a7509ca59d" => :mountain_lion
  end

  depends_on "sdl"

  # fix issue due to bug in OSX Firewire stack
  # libdc1394 author comments here:
  # http://permalink.gmane.org/gmane.comp.multimedia.libdc1394.devel/517
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-sdltest"
    system "make install"
  end
end

__END__
diff --git a/dc1394/macosx/capture.c b/dc1394/macosx/capture.c
index c7c71f2..8959535 100644
--- a/dc1394/macosx/capture.c
+++ b/dc1394/macosx/capture.c
@@ -150,7 +150,7 @@ callback (buffer_info * buffer, NuDCLRef dcl)
 
     for (i = 0; i < buffer->num_dcls; i++) {
         int packet_size = capture->frames[buffer->i].packet_size;
-        if ((buffer->pkts[i].status & 0x1F) != 0x11) {
+        if (buffer->pkts[i].status && (buffer->pkts[i].status & 0x1F) != 0x11) {
             dc1394_log_warning ("packet %d had error status %x",
                     i, buffer->pkts[i].status);
             corrupt = 1;
