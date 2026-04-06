import PalettePreviewCard from '@/components/PalettePreviewCard';

export const metadata = {
  title: 'Palette Refactor',
  description: 'Clean professional color palette preview',
};

export default function PalettePage() {
  return (
    <main className="palette-page">
      <div className="palette-page-copy">
        <span className="palette-kicker">Refined Palette UI</span>
        <h1 className="palette-page-title">Clean image color picker layout</h1>
        <p className="palette-page-text">
          A flatter, more professional palette presentation with soft neutrals,
          restrained shadows, and almost no gradient treatment.
        </p>
      </div>

      <PalettePreviewCard />
    </main>
  );
}
