'use client';

import { useState } from 'react';
import { Download, Heart, Link2, Check } from 'lucide-react';

const palette = ['#F6F8FA', '#D8E1E8', '#AEBCC8', '#5A6A78', '#1F2428'];

function hexToRgb(hex) {
  const normalized = hex.replace('#', '');
  const value = parseInt(normalized, 16);
  const r = (value >> 16) & 255;
  const g = (value >> 8) & 255;
  const b = value & 255;
  return `rgb(${r}, ${g}, ${b})`;
}

function ActionButton({ icon: Icon, label, subtle = false }) {
  return (
    <button
      type="button"
      className={subtle ? 'palette-action palette-action-subtle' : 'palette-action'}
    >
      <Icon size={18} strokeWidth={2} />
      <span>{label}</span>
    </button>
  );
}

export default function PalettePreviewCard() {
  const [copiedValue, setCopiedValue] = useState('');

  async function copyText(value) {
    try {
      await navigator.clipboard.writeText(value);
      setCopiedValue(value);
      window.setTimeout(() => setCopiedValue(''), 1400);
    } catch {
      setCopiedValue('');
    }
  }

  return (
    <section className="palette-shell">
      <div className="palette-card">
        <div className="palette-hero" aria-label="Palette preview">
          {palette.map((color) => (
            <div
              key={color}
              className="palette-band"
              style={{ backgroundColor: color }}
            />
          ))}
        </div>

        <div className="palette-toolbar">
          <div className="palette-toolbar-left">
            <ActionButton icon={Heart} label="20,830" subtle />
            <ActionButton icon={Download} label="Image" subtle />
            <ActionButton icon={Link2} label="Link" subtle />
          </div>
          <span className="palette-age">10 years</span>
        </div>

        <button type="button" className="palette-like-button">
          Like this palette?
        </button>

        <div className="palette-swatch-grid">
          {palette.map((color) => {
            const isCopied = copiedValue === color;
            return (
              <button
                type="button"
                key={color}
                className="palette-swatch-card"
                onClick={() => copyText(color)}
              >
                <span
                  className="palette-swatch"
                  style={{ backgroundColor: color }}
                  aria-hidden="true"
                />
                <span className="palette-hex-row">
                  <span className="palette-hex">{color}</span>
                  {isCopied ? <Check size={16} strokeWidth={2.3} /> : null}
                </span>
                <span className="palette-rgb">{hexToRgb(color)}</span>
              </button>
            );
          })}
        </div>
      </div>
    </section>
  );
}
