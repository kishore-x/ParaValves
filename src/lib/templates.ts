/** Standard check sheets per inspection stage (valve manufacturing). */
export const INSPECTION_TEMPLATES: Record<string, string[]> = {
  INCOMING: ['Dimensional check vs drawing', 'Material / heat certificate matches lot', 'Visual & surface condition', 'Hardness / PMI (if specified)'],
  IN_PROCESS: ['Machined dimensions', 'Surface finish', 'Thread / bore gauge'],
  FINAL: ['Visual, marking & nameplate', 'Face-to-face & end dimensions', 'Seat & stem operation (torque)', 'Tag / serial verified'],
};
