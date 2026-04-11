'use client';

import { ChevronDown, ChevronUp, ChevronsUpDown } from 'lucide-react';
import { useMemo, useState } from 'react';

function normalizeValue(value) {
  if (value === null || value === undefined) return '';
  if (typeof value === 'number') return value;
  if (value instanceof Date) return value.getTime();
  const parsed = Date.parse(value);
  if (!Number.isNaN(parsed) && String(value).includes('-')) return parsed;
  return String(value).toLowerCase();
}

export default function StudentDataTable({
  columns,
  rows,
  rowKey = (row) => row.id,
  pageSize = 6,
  initialSortKey,
  initialSortDirection = 'asc',
  emptyState,
}) {
  const [sortKey, setSortKey] = useState(initialSortKey ?? columns.find((column) => column.sortable)?.key ?? null);
  const [sortDirection, setSortDirection] = useState(initialSortDirection);
  const [page, setPage] = useState(1);

  const sortedRows = useMemo(() => {
    if (!sortKey) return rows;
    const column = columns.find((item) => item.key === sortKey);
    if (!column) return rows;

    return [...rows].sort((left, right) => {
      const leftValue = normalizeValue(column.sortValue ? column.sortValue(left) : left[sortKey]);
      const rightValue = normalizeValue(column.sortValue ? column.sortValue(right) : right[sortKey]);

      if (leftValue < rightValue) return sortDirection === 'asc' ? -1 : 1;
      if (leftValue > rightValue) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    });
  }, [columns, rows, sortDirection, sortKey]);

  const totalPages = Math.max(1, Math.ceil(sortedRows.length / pageSize));
  const safePage = Math.min(page, totalPages);
  const pagedRows = sortedRows.slice((safePage - 1) * pageSize, safePage * pageSize);

  function handleSort(columnKey) {
    if (sortKey === columnKey) {
      setSortDirection((current) => (current === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortKey(columnKey);
      setSortDirection('asc');
    }
    setPage(1);
  }

  if (!rows.length) {
    return emptyState ?? null;
  }

  return (
    <div className="space-y-4">
      <div className="overflow-x-auto rounded-[1.4rem] border border-slate-200/70 bg-white/75">
        <table className="min-w-full text-sm">
          <thead className="bg-slate-50/80">
            <tr>
              {columns.map((column) => {
                const active = sortKey === column.key;
                const SortIcon = !column.sortable ? null : active ? (sortDirection === 'asc' ? ChevronUp : ChevronDown) : ChevronsUpDown;

                return (
                  <th key={column.key} className={`px-4 py-3 text-left font-semibold text-slate-600 ${column.headerClassName ?? ''}`}>
                    {column.sortable ? (
                      <button
                        type="button"
                        onClick={() => handleSort(column.key)}
                        className="inline-flex items-center gap-1 transition hover:text-slate-900"
                      >
                        {column.label}
                        {SortIcon ? <SortIcon className="h-4 w-4" /> : null}
                      </button>
                    ) : (
                      column.label
                    )}
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {pagedRows.map((row, index) => (
              <tr key={rowKey(row) ?? index} className="transition hover:bg-slate-50/60">
                {columns.map((column) => (
                  <td key={column.key} className={`px-4 py-3 align-top text-slate-600 ${column.cellClassName ?? ''}`}>
                    {column.render ? column.render(row) : row[column.key]}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {totalPages > 1 ? (
        <div className="flex items-center justify-between gap-3">
          <p className="text-sm text-slate-500">
            Page {safePage} of {totalPages}
          </p>
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => setPage((current) => Math.max(1, current - 1))}
              disabled={safePage === 1}
              className="rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-600 transition hover:border-slate-300 hover:text-slate-900 disabled:cursor-not-allowed disabled:opacity-50"
            >
              Previous
            </button>
            <button
              type="button"
              onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
              disabled={safePage === totalPages}
              className="rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-600 transition hover:border-slate-300 hover:text-slate-900 disabled:cursor-not-allowed disabled:opacity-50"
            >
              Next
            </button>
          </div>
        </div>
      ) : null}
    </div>
  );
}
