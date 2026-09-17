# TOTAT — Code Conventions
# GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI


## File Naming
- Pages: /src/pages/[modul]/page.tsx
- Components: PascalCase.tsx
- Hooks: use-kebab-case.ts
- Lib: kebab-case.ts


## Component Pattern
export default function NamaPage() {
  // 1. Auth + queries
  // 2. Local state
  // 3. Handlers
  // 4. Loading states
  // 5. Render
}


## Utilities (/src/lib/format.ts)
formatRp(15000)           // "Rp 15.000"
formatDate("2026-09-12")  // "12 Sep 2026"


## Toast — always sonner
import { toast } from "sonner";
toast.success("Berhasil disimpan");
toast.error("Gagal: " + error.message);


## Modal — always Sheet from bottom
import { Sheet, SheetContent } from "@/components/ui/sheet";
<Sheet open={open} onOpenChange={setOpen}>
  <SheetContent side="bottom">...</SheetContent>
</Sheet>


## File/Camera — NEVER getUserMedia
<input type="file" accept="image/*" capture="environment" />


## Bahasa Indonesia UI Copy
"Simpan" not "Save"    | "Batal" not "Cancel"
"Hapus" not "Delete"   | "Tambah" not "Add"
"kamu" not "Anda"      | "warung" not "outlet"
Error: "Gagal menyimpan — coba lagi" (not "Error 500")
Empty: "Belum ada [item]. Tambah [item] pertama →"


## DO
- Use existing shadcn/ui components
- Mobile-first, touch targets min 44px
- formatRp() for all currency display
- Offline-first logic for core features
- Additive only — never refactor working features


## DON'T
- Create new UI primitives if shadcn has it
- getUserMedia / WebRTC
- Auto-send email/WA — user must trigger
- alert() or confirm() — use sonner + dialog
- Hard-code user IDs
- Refactor working features without explicit approval


## Commit Convention
feat(modul): deskripsi
fix(modul): deskripsi
chore: deskripsi