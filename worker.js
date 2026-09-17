// Routes each TOTAT subdomain to its own sites/[module]/ folder.
// Needed because Workers static-asset routing matches request PATH against
// one shared assets directory — with many custom domains on this single
// Worker, they'd otherwise all resolve "/" to the same file. This script
// rewrites the path based on the Host header before handing off to the
// ASSETS binding.

const HOST_TO_MODULE = {
  "totat.my.id": "main",
  "www.totat.my.id": "main",
  "warung.totat.my.id": "warung",
  "cafe.totat.my.id": "cafe",
  "sewa.totat.my.id": "sewa",
  "tamu.totat.my.id": "tamu",
  "jasa.totat.my.id": "jasa",
  "talent.totat.my.id": "talent",
  "kanal.totat.my.id": "kanal",
  "kirim.totat.my.id": "kirim",
  "jaringan.totat.my.id": "jaringan",
  "investor.totat.my.id": "investor",
  "distribusi.totat.my.id": "distribusi",
  "karir.totat.my.id": "karir",
};

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const host = url.hostname.toLowerCase();
    const module = HOST_TO_MODULE[host] || "main";

    let pathname = url.pathname;
    if (pathname === "/" || pathname === "") {
      pathname = "/index.html";
    }

    const assetUrl = new URL(`/${module}${pathname}`, url.origin);
    const assetRequest = new Request(assetUrl.toString(), request);
    return env.ASSETS.fetch(assetRequest);
  },
};
